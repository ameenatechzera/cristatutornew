import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cristalteacher/core/appdata/appdata.dart';
import 'package:cristalteacher/core/utils/text_stylepicker.dart.dart';
import 'package:cristalteacher/features/diary/domain/parameters/save_diary_parameter.dart';
import 'package:cristalteacher/features/diary/domain/parameters/update_diary_parameter.dart';
import 'package:cristalteacher/features/diary/presentation/cubit/diary_cubit.dart';
import 'package:cristalteacher/features/diary/presentation/screens/diary_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:url_launcher/url_launcher.dart';

enum VoiceState { idle, recording, recorded }

class SelectedDiaryFile {
  final String name;
  final String extension;
  final Uint8List bytes;
  final int size;

  const SelectedDiaryFile({
    required this.name,
    required this.extension,
    required this.bytes,
    required this.size,
  });

  String get mimeType {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'mp3':
        return 'audio/mpeg';
      default:
        return 'application/octet-stream';
    }
  }

  String get dataUri {
    return 'data:$mimeType;base64,${base64Encode(bytes)}';
  }
}

class SelectYourClassScreen extends StatefulWidget {
  /// Null when creating. Set when the diary is being edited.
  final int? diaryId;

  final int standardId;
  final String standardName;

  final int divisionId;
  final String divisionName;

  final int subjectId;
  final String subjectName;

  final DateTime diaryDate;
  final DateTime dueDate;

  final bool isFavourite;

  /// Optional values already loaded by CreateDiaryScreen. Used as the
  /// immediate prefill so the fields are never blank; the API response
  /// overwrites them when it lands.
  final String initialTitle;
  final String initialDescription;
  final List<String> existingFiles;

  const SelectYourClassScreen({
    super.key,
    this.diaryId,
    required this.standardId,
    required this.standardName,
    required this.divisionId,
    required this.divisionName,
    required this.subjectId,
    required this.subjectName,
    required this.diaryDate,
    required this.dueDate,
    required this.isFavourite,
    this.initialTitle = '',
    this.initialDescription = '',
    this.existingFiles = const <String>[],
  });

  @override
  State<SelectYourClassScreen> createState() => _SelectYourClassScreenState();
}

class _SelectYourClassScreenState extends State<SelectYourClassScreen> {
  // Rich controllers: size, colour, bold, italic and underline are all held
  // per character, so the style sheet changes the selected text only.
  final RichTextEditingController _titleController =
      RichTextEditingController();
  final RichTextEditingController _descriptionController =
      RichTextEditingController();

  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<SelectedDiaryFile> _selectedFiles = [];

  /// Attachment URLs already stored on the server. Whatever is left here
  /// is sent back untouched, so an update does not wipe them.
  final List<String> _existingFiles = [];

  /// True while fetchDiaryUpdateListing is in flight.
  bool _isLoadingDiary = false;

  VoiceState voiceState = VoiceState.idle;

  Timer? _recordingTimer;

  Duration _recordingDuration = Duration.zero;
  Duration _playbackPosition = Duration.zero;
  Duration _playbackDuration = Duration.zero;

  String? _recordedAudioPath;
  bool _isPlaying = false;
  bool _isPickingFiles = false;

  static const int _maximumFileSize = 10 * 1024 * 1024;

  static const List<String> _allowedExtensions = [
    'pdf',
    'doc',
    'docx',
    'jpg',
    'jpeg',
    'png',
    'mp3',
  ];

  /// Extensions shown as a picture instead of an icon.
  static const List<String> _imageExtensions = ['jpg', 'jpeg', 'png'];

  final Color bgColor = const Color(0xffFBF7FF);
  final Color fieldColor = const Color(0xffEEF4FF);
  final Color primaryColor = const Color(0xff9B73E6);
  final Color borderColor = const Color(0xffB7C4D6);

  /// Palette handed to the shared input field / picker.
  EditorStyleTheme get _styleTheme {
    return EditorStyleTheme(
      accentColor: primaryColor,
      fillColor: fieldColor,
      borderColor: borderColor,
    );
  }

  bool get isEditMode => widget.diaryId != null;

  @override
  void initState() {
    super.initState();

    _configureAudioPlayer();

    // Immediate prefill from whatever the previous screen already had.
    // setHtml restores every run's formatting, not just the plain text.
    _titleController.setHtml(widget.initialTitle);
    _descriptionController.setHtml(widget.initialDescription);

    _existingFiles.addAll(
      widget.existingFiles.where((file) => file.trim().isNotEmpty),
    );

    if (isEditMode) {
      _isLoadingDiary = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        _fetchDiaryForEdit();
      });
    }

    debugPrint('==========================================');
    debugPrint('SELECTED DIARY DETAILS');
    debugPrint(
      'Mode        : ${isEditMode ? 'EDIT (${widget.diaryId})' : 'CREATE'}',
    );
    debugPrint('Standard    : ${widget.standardName} (${widget.standardId})');
    debugPrint('Division    : ${widget.divisionName} (${widget.divisionId})');
    debugPrint('Subject     : ${widget.subjectName} (${widget.subjectId})');
    debugPrint('Diary Date  : ${formatApiDate(widget.diaryDate)}');
    debugPrint('Due Date    : ${formatApiDate(widget.dueDate)}');
    debugPrint('Is Favourite: ${widget.isFavourite}');
    debugPrint('Employee ID : ${AppData.employeeId}');
    debugPrint('==========================================');
  }

  void _fetchDiaryForEdit() {
    debugPrint('==========================================');
    debugPrint('LOADING DIARY CONTENT FOR EDIT');
    debugPrint('Diary ID: ${widget.diaryId}');
    debugPrint('==========================================');

    context.read<DiaryCubit>().fetchDiaryUpdateListing(widget.diaryId!);
  }

  /// Puts the fetched diary onto the form.
  void _applyDiaryDetails(dynamic data) {
    final String rawTitle = data.diaryTitle?.toString() ?? '';
    final String rawDescription = data.description?.toString() ?? '';

    final List<String> files = List<String>.from(
      data.files ?? const [],
    ).where((file) => file.trim().isNotEmpty).toList();

    // Restores the size, colour, bold, italic and underline the diary was
    // saved with, run by run.
    _titleController.setHtml(rawTitle);
    _descriptionController.setHtml(rawDescription);

    setState(() {
      _existingFiles
        ..clear()
        ..addAll(files);
    });

    debugPrint('==========================================');
    debugPrint('EDIT CONTENT APPLIED');
    debugPrint('Title      : ${_titleController.text}');
    debugPrint('Description: ${_descriptionController.text}');
    debugPrint('Files      : ${files.length}');
    debugPrint('==========================================');
  }

  void _configureAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      if (!mounted) return;

      setState(() {
        _playbackDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (!mounted) return;

      setState(() {
        _playbackPosition = position;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;

      setState(() {
        _isPlaying = false;
        _playbackPosition = Duration.zero;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;

      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();

    _titleController.dispose();
    _descriptionController.dispose();

    _audioRecorder.dispose();
    _audioPlayer.dispose();

    super.dispose();
  }

  String formatApiDate(DateTime date) {
    final String year = date.year.toString();
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds.remainder(60);

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_outlined;
      case 'mp3':
      case 'm4a':
      case 'aac':
      case 'wav':
        return Icons.audio_file_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  bool _isImage(String extension) {
    return _imageExtensions.contains(extension.toLowerCase());
  }

  String _fileNameFromUrl(String url) {
    final String cleaned = url.trim().replaceAll('\\', '/');
    final Uri? uri = Uri.tryParse(cleaned);
    final List<String> segments = uri?.pathSegments ?? const [];

    if (segments.isNotEmpty) {
      return Uri.decodeComponent(segments.last);
    }

    return 'Attachment';
  }

  String _extensionFromUrl(String url) {
    final String name = _fileNameFromUrl(url);
    final int dotIndex = name.lastIndexOf('.');

    if (dotIndex == -1) {
      return '';
    }

    return name.substring(dotIndex + 1).toLowerCase();
  }

  Future<void> _pickAttachments() async {
    if (_isPickingFiles) return;

    setState(() {
      _isPickingFiles = true;
    });

    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: _allowedExtensions,
        withData: true,
      );

      if (result == null) {
        return;
      }

      final List<SelectedDiaryFile> newFiles = [];

      for (final PlatformFile platformFile in result.files) {
        final String extension = (platformFile.extension ?? '').toLowerCase();

        if (!_allowedExtensions.contains(extension)) {
          _showMessage('${platformFile.name} is not a supported file');
          continue;
        }

        if (platformFile.size > _maximumFileSize) {
          _showMessage('${platformFile.name} exceeds the 10 MB limit');
          continue;
        }

        Uint8List? bytes = platformFile.bytes;

        if (bytes == null && platformFile.path != null) {
          bytes = await File(platformFile.path!).readAsBytes();
        }

        if (bytes == null || bytes.isEmpty) {
          _showMessage('Unable to read ${platformFile.name}');
          continue;
        }

        final bool alreadySelected = _selectedFiles.any(
          (file) =>
              file.name == platformFile.name && file.size == platformFile.size,
        );

        final bool duplicatedInCurrentSelection = newFiles.any(
          (file) =>
              file.name == platformFile.name && file.size == platformFile.size,
        );

        if (alreadySelected || duplicatedInCurrentSelection) {
          continue;
        }

        newFiles.add(
          SelectedDiaryFile(
            name: platformFile.name,
            extension: extension,
            bytes: bytes,
            size: platformFile.size,
          ),
        );
      }

      if (!mounted) return;

      setState(() {
        _selectedFiles.addAll(newFiles);
      });

      if (newFiles.isNotEmpty) {
        _showMessage(
          '${newFiles.length} attachment'
          '${newFiles.length == 1 ? '' : 's'} selected',
        );
      }
    } catch (error, stackTrace) {
      debugPrint('Attachment selection error: $error');
      debugPrintStack(stackTrace: stackTrace);

      _showMessage('Unable to select attachments');
    } finally {
      if (mounted) {
        setState(() {
          _isPickingFiles = false;
        });
      }
    }
  }

  void _removeAttachment(int index) {
    if (index < 0 || index >= _selectedFiles.length) {
      return;
    }

    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  /// Removing an existing attachment only drops it from the list that is
  /// sent back, which is what deletes it on the server.
  void _removeExistingAttachment(int index) {
    if (index < 0 || index >= _existingFiles.length) {
      return;
    }

    setState(() {
      _existingFiles.removeAt(index);
    });
  }

  Future<void> _startRecording() async {
    try {
      await _audioPlayer.stop();

      final bool hasPermission = await _audioRecorder.hasPermission();

      if (!hasPermission) {
        _showMessage('Microphone permission is required to record audio');
        return;
      }

      final Directory temporaryDirectory = await getTemporaryDirectory();

      final String audioPath =
          '${temporaryDirectory.path}/diary_voice_'
          '${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: audioPath,
      );

      _recordingTimer?.cancel();

      if (!mounted) return;

      setState(() {
        _recordedAudioPath = audioPath;
        _recordingDuration = Duration.zero;
        _playbackPosition = Duration.zero;
        _playbackDuration = Duration.zero;
        _isPlaying = false;
        voiceState = VoiceState.recording;
      });

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;

        setState(() {
          _recordingDuration += const Duration(seconds: 1);
        });
      });
    } catch (error, stackTrace) {
      debugPrint('Start recording error: $error');
      debugPrintStack(stackTrace: stackTrace);

      _showMessage('Unable to start voice recording');

      if (mounted) {
        setState(() {
          voiceState = VoiceState.idle;
        });
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      _recordingTimer?.cancel();
      _recordingTimer = null;

      final String? path = await _audioRecorder.stop();

      if (path == null) {
        throw Exception('Recording path was not returned');
      }

      final File audioFile = File(path);

      if (!await audioFile.exists()) {
        throw Exception('Recorded audio file does not exist');
      }

      final int audioSize = await audioFile.length();

      if (audioSize <= 0) {
        throw Exception('Recorded audio file is empty');
      }

      if (!mounted) return;

      setState(() {
        _recordedAudioPath = path;
        _playbackDuration = _recordingDuration;
        _playbackPosition = Duration.zero;
        voiceState = VoiceState.recorded;
      });
    } catch (error, stackTrace) {
      debugPrint('Stop recording error: $error');
      debugPrintStack(stackTrace: stackTrace);

      _showMessage('Unable to save voice recording');

      if (mounted) {
        setState(() {
          _recordedAudioPath = null;
          voiceState = VoiceState.idle;
        });
      }
    }
  }

  Future<void> _toggleAudioPlayback() async {
    final String? audioPath = _recordedAudioPath;

    if (audioPath == null || audioPath.isEmpty) {
      _showMessage('Recorded audio is not available');
      return;
    }

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        return;
      }

      final PlayerState playerState = _audioPlayer.state;

      if (playerState == PlayerState.paused) {
        await _audioPlayer.resume();
      } else {
        await _audioPlayer.play(DeviceFileSource(audioPath));
      }
    } catch (error, stackTrace) {
      debugPrint('Audio playback error: $error');
      debugPrintStack(stackTrace: stackTrace);

      _showMessage('Unable to play the recorded audio');
    }
  }

  Future<void> _deleteRecording() async {
    try {
      _recordingTimer?.cancel();
      _recordingTimer = null;

      if (await _audioRecorder.isRecording()) {
        await _audioRecorder.stop();
      }

      await _audioPlayer.stop();

      final String? audioPath = _recordedAudioPath;

      if (audioPath != null && audioPath.isNotEmpty) {
        final File audioFile = File(audioPath);

        if (await audioFile.exists()) {
          await audioFile.delete();
        }
      }
    } catch (error) {
      debugPrint('Delete recording error: $error');
    } finally {
      if (mounted) {
        setState(() {
          _recordedAudioPath = null;
          _recordingDuration = Duration.zero;
          _playbackDuration = Duration.zero;
          _playbackPosition = Duration.zero;
          _isPlaying = false;
          voiceState = VoiceState.idle;
        });
      }
    }
  }

  /// Kept server URLs first, then newly picked files, then the recording.
  Future<List<String>> _buildApiFiles() async {
    final List<String> files = [
      ..._existingFiles,
      ..._selectedFiles.map((file) => file.dataUri),
    ];

    final String? recordedAudioPath = _recordedAudioPath;

    if (recordedAudioPath != null &&
        recordedAudioPath.isNotEmpty &&
        voiceState == VoiceState.recorded) {
      final File audioFile = File(recordedAudioPath);

      if (await audioFile.exists()) {
        final Uint8List audioBytes = await audioFile.readAsBytes();

        if (audioBytes.isNotEmpty) {
          files.add('data:audio/mp4;base64,${base64Encode(audioBytes)}');
        }
      }
    }

    return files;
  }

  /// Runs the create or the update request, depending on diaryId.
  Future<void> _saveDiary() async {
    FocusScope.of(context).unfocus();

    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();

    debugPrint('');
    debugPrint('==================================================');
    debugPrint('${isEditMode ? 'UPDATE' : 'SAVE'} DIARY BUTTON PRESSED');
    debugPrint('==================================================');
    debugPrint('Diary ID      : ${widget.diaryId}');
    debugPrint('Standard ID   : ${widget.standardId}');
    debugPrint('Division ID   : ${widget.divisionId}');
    debugPrint('Subject ID    : ${widget.subjectId}');
    debugPrint('Title         : $title');
    debugPrint('Description   : $description');
    debugPrint('Voice State   : $voiceState');
    debugPrint('Kept files    : ${_existingFiles.length}');
    debugPrint('New files     : ${_selectedFiles.length}');

    if (voiceState == VoiceState.recording) {
      _showMessage('Please stop the voice recording before saving');
      return;
    }

    if (title.isEmpty) {
      _showMessage('Please enter Heading or Title');
      return;
    }

    if (description.isEmpty) {
      _showMessage('Please enter Description');
      return;
    }

    if (AppData.accYear == null) {
      _showMessage('Academic year is not available');
      return;
    }

    if (AppData.employeeId == null) {
      _showMessage('Employee ID is not available');
      return;
    }

    // Every formatted run travels as its own inline span.
    final String styledTitle = _titleController.toHtml();
    final String styledDescription = _descriptionController.toHtml();

    try {
      final List<String> apiFiles = await _buildApiFiles();

      debugPrint('Total files sent: ${apiFiles.length}');

      if (!mounted) return;

      // ---------------- UPDATE ----------------
      if (isEditMode) {
        final UpdateDiaryParameter request = UpdateDiaryParameter(
          accYear: AppData.accYear!,
          standardId: widget.standardId,
          divisionId: widget.divisionId,
          subjectId: widget.subjectId,
          employeeId: AppData.employeeId!,
          diaryType: null,
          diaryTitle: styledTitle,
          description: styledDescription,
          diaryDate: formatApiDate(widget.diaryDate),
          dueDate: formatApiDate(widget.dueDate),
          isActive: true,
          isFavourite: widget.isFavourite,
          branchId: AppData.branchId ?? 1,
          modifiedUser: AppData.userId.toString(),
          files: apiFiles,
          videoUrl: '',
        );

        debugPrint('');
        debugPrint('==================================================');
        debugPrint('UPDATE DIARY REQUEST');
        debugPrint('==================================================');

        _printRequestJson(request.toJson());

        await context.read<DiaryCubit>().updateDiary(request, widget.diaryId!);
        return;
      }

      // ---------------- CREATE ----------------
      final SaveDiaryParameter request = SaveDiaryParameter(
        accYear: AppData.accYear!,
        standardId: widget.standardId,
        divisionId: widget.divisionId,
        subjectId: widget.subjectId,
        employeeId: AppData.employeeId!,
        diaryType: null,
        diaryTitle: styledTitle,
        description: styledDescription,
        diaryDate: formatApiDate(widget.diaryDate),
        dueDate: formatApiDate(widget.dueDate),
        isActive: true,
        isFavourite: widget.isFavourite,
        branchId: AppData.branchId ?? 1,
        createdUser: AppData.userId.toString(),
        files: apiFiles,
        videoUrl: '',
      );

      debugPrint('');
      debugPrint('==================================================');
      debugPrint('SAVE DIARY REQUEST');
      debugPrint('==================================================');

      _printRequestJson(request.toJson());

      await context.read<DiaryCubit>().saveDiary(request);
    } catch (error, stackTrace) {
      debugPrint('Prepare diary request error: $error');
      debugPrintStack(stackTrace: stackTrace);

      _showMessage('Unable to prepare attachments');
    }
  }

  /// Prints the request without dumping whole base64 payloads.
  void _printRequestJson(Map<String, dynamic> requestJson) {
    requestJson.forEach((key, value) {
      if (key == 'files') {
        final List<dynamic> files = value is List ? value : [];

        debugPrint('$key : ${files.length} file(s)');

        for (int i = 0; i < files.length; i++) {
          final String file = files[i].toString();

          debugPrint(
            '  File ${i + 1}: '
            '${file.length > 40 ? file.substring(0, 40) : file}',
          );
        }
      } else {
        debugPrint('$key : $value');
      }
    });

    debugPrint('==================================================');
  }

  /// Shared cleanup + navigation for both create and update success.
  Future<void> _onDiarySubmitted(String apiMessage) async {
    _showMessage(
      apiMessage.trim().isNotEmpty
          ? apiMessage
          : isEditMode
          ? 'Diary updated successfully'
          : 'Diary saved successfully',
    );

    _titleController.clear();
    _descriptionController.clear();
    _selectedFiles.clear();
    _existingFiles.clear();

    await _deleteRecording();

    if (!mounted) return;

    if (isEditMode) {
      // diary -> create -> details, so two pops land back on the list the
      // user was already looking at, with its filter and date range intact.
      // Its edit button awaits this push and reloads the list itself.
      Navigator.of(context)
        ..pop()
        ..pop();

      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DiaryTypeScreen()),

      // Keeps the dashboard and removes the diary creation screens.
      (route) => route.isFirst,
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiaryCubit, DiaryState>(
      listenWhen: (previous, current) {
        return current is SaveDiarySuccess ||
            current is UpdateDiarySuccess ||
            current is UpdateDiaryFailure ||
            current is FetchDiaryUpdateListingSuccess ||
            current is FetchDiaryUpdateListingFailure ||
            current is DiaryFailure;
      },
      listener: (context, state) async {
        // ---------- diary loaded for editing ----------
        if (state is FetchDiaryUpdateListingSuccess) {
          setState(() {
            _isLoadingDiary = false;
          });

          final data = state.response.data;

          if (data == null) {
            _showMessage('Diary details are not available');
            return;
          }

          _applyDiaryDetails(data);
          return;
        }

        if (state is FetchDiaryUpdateListingFailure) {
          setState(() {
            _isLoadingDiary = false;
          });

          _showMessage(state.message);
          return;
        }

        // ---------- diary created ----------
        if (state is SaveDiarySuccess) {
          await _onDiarySubmitted(state.response.message?.toString() ?? '');
          return;
        }

        // ---------- diary updated ----------
        if (state is UpdateDiarySuccess) {
          await _onDiarySubmitted(state.response.message?.toString() ?? '');
          return;
        }

        if (state is UpdateDiaryFailure) {
          _showMessage(state.message);
          return;
        }

        if (state is DiaryFailure) {
          _showMessage(state.message);
        }
      },
      builder: (context, state) {
        final bool isSaving =
            state is SaveDiaryLoading || state is UpdateDiaryLoading;

        return PopScope(
          canPop: !isSaving && voiceState != VoiceState.recording,
          child: Scaffold(
            backgroundColor: bgColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _buildHeader(isSaving),
                    const SizedBox(height: 28),
                    Expanded(
                      child: _isLoadingDiary
                          ? Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : SingleChildScrollView(
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              child: Column(
                                children: [
                                  StyledInputField(
                                    controller: _titleController,
                                    hint: 'Heading Or Title',
                                    minHeight: 44,
                                    maxLines: 1,
                                    enabled: !isSaving,
                                    theme: _styleTheme,
                                  ),
                                  const SizedBox(height: 14),
                                  StyledInputField(
                                    controller: _descriptionController,
                                    hint: 'Description',
                                    minHeight: 118,
                                    maxLines: 5,
                                    enabled: !isSaving,
                                    theme: _styleTheme,
                                  ),
                                  const SizedBox(height: 14),

                                  // Picked images and files preview inside
                                  // the box itself.
                                  _attachmentBox(isSaving),

                                  const SizedBox(height: 10),
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.info,
                                        size: 15,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          'Allow Pdf, Doc, Docx, Jpg, Png, Mp3. Maximum 10 MB each.',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Color(0xff5C5C5C),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _voiceWidget(isSaving),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isSaving || _isLoadingDiary
                            ? null
                            : _saveDiary,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          disabledBackgroundColor: primaryColor.withOpacity(
                            0.6,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: isSaving
                            ? const SizedBox(
                                width: 21,
                                height: 21,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                isEditMode ? 'Update' : 'Save',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isSaving) {
    final bool locked = isSaving || voiceState == VoiceState.recording;

    return Row(
      children: [
        GestureDetector(
          onTap: locked
              ? null
              : () {
                  Navigator.maybePop(context);
                },
          child: Icon(
            Icons.arrow_back,
            size: 22,
            color: locked ? Colors.grey : Colors.black,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              isEditMode ? 'Edit Diary' : 'Select Your Class',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 22),
      ],
    );
  }

  /// Empty: the upload prompt. With attachments: a row of thumbnails inside
  /// the same dashed box, images shown as pictures.
  Widget _attachmentBox(bool isSaving) {
    final bool hasFiles =
        _existingFiles.isNotEmpty || _selectedFiles.isNotEmpty;

    return CustomPaint(
      painter: DashedBorderPainter(),
      child: SizedBox(
        width: double.infinity,
        height: 105,
        child: hasFiles
            ? _buildAttachmentPreviews(isSaving)
            : _buildEmptyAttachment(isSaving),
      ),
    );
  }

  Widget _buildEmptyAttachment(bool isSaving) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isSaving || _isPickingFiles ? null : _pickAttachments,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isPickingFiles)
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: primaryColor,
              ),
            )
          else
            SvgPicture.asset(
              'assets/icons/Group (9).svg',
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          const SizedBox(height: 6),
          Text(
            _isPickingFiles ? 'Selecting...' : 'Attachment',
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentPreviews(bool isSaving) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      children: [
        // Already on the server.
        for (int index = 0; index < _existingFiles.length; index++)
          _attachmentTile(
            preview: _existingFilePreview(_existingFiles[index]),
            onTap: _isImage(_extensionFromUrl(_existingFiles[index]))
                ? () => _openImageViewer(
                    NetworkImage(_existingFiles[index]),
                    _fileNameFromUrl(_existingFiles[index]),
                  )
                : () => _openExistingDocument(_existingFiles[index]),
            onRemove: isSaving ? null : () => _removeExistingAttachment(index),
          ),

        // Picked in this session.
        for (int index = 0; index < _selectedFiles.length; index++)
          _attachmentTile(
            preview: _selectedFilePreview(_selectedFiles[index]),
            onTap: _isImage(_selectedFiles[index].extension)
                ? () => _openImageViewer(
                    MemoryImage(_selectedFiles[index].bytes),
                    _selectedFiles[index].name,
                  )
                : () => _openSelectedDocument(_selectedFiles[index]),
            onRemove: isSaving ? null : () => _removeAttachment(index),
          ),

        _addMoreTile(isSaving),
      ],
    );
  }

  /// Shows the tapped attachment on its own screen.
  void _openImageViewer(ImageProvider image, String title) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) {
          return FullScreenImageViewer(image: image, title: title);
        },
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 180),
      ),
    );
  }

  /// A PDF or document already on the server. It has a real URL, so the
  /// device opens it directly.
  Future<void> _openExistingDocument(String fileUrl) async {
    final Uri? uri = Uri.tryParse(fileUrl.trim());

    if (uri == null || !uri.hasScheme) {
      _showMessage('This attachment cannot be opened');
      return;
    }

    try {
      final bool opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        _showMessage('No app available to open this file');
      }
    } catch (error, stackTrace) {
      debugPrint('Open attachment error: $error');
      debugPrintStack(stackTrace: stackTrace);

      _showMessage('Unable to open this attachment');
    }
  }

  /// A PDF or document picked in this session. It only exists as bytes in
  /// memory, so it is written to the temp folder before being handed to
  /// whichever app the device uses for that type.
  Future<void> _openSelectedDocument(SelectedDiaryFile file) async {
    try {
      final Directory temporaryDirectory = await getTemporaryDirectory();

      final Directory attachmentDirectory = Directory(
        '${temporaryDirectory.path}/diary_attachments',
      );

      if (!await attachmentDirectory.exists()) {
        await attachmentDirectory.create(recursive: true);
      }

      final File target = File('${attachmentDirectory.path}/${file.name}');

      await target.writeAsBytes(file.bytes, flush: true);

      final OpenResult result = await OpenFilex.open(
        target.path,
        type: file.mimeType,
      );

      if (result.type != ResultType.done) {
        _showMessage('No app available to open ${file.name}');
      }
    } catch (error, stackTrace) {
      debugPrint('Open picked attachment error: $error');
      debugPrintStack(stackTrace: stackTrace);

      _showMessage('Unable to open ${file.name}');
    }
  }

  /// Server attachment: the picture itself for images, an icon otherwise.
  Widget _existingFilePreview(String fileUrl) {
    final String extension = _extensionFromUrl(fileUrl);

    if (_isImage(extension)) {
      return Image.network(
        fileUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fileIconPreview(extension),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;

          return Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: primaryColor,
              ),
            ),
          );
        },
      );
    }

    return _fileIconPreview(extension);
  }

  /// Newly picked attachment: drawn straight from the bytes already in
  /// memory, so no temp file is needed.
  Widget _selectedFilePreview(SelectedDiaryFile file) {
    if (_isImage(file.extension)) {
      return Image.memory(
        file.bytes,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fileIconPreview(file.extension),
      );
    }

    return _fileIconPreview(file.extension, label: file.extension);
  }

  Widget _fileIconPreview(String extension, {String? label}) {
    return Container(
      color: fieldColor,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getFileIcon(extension), size: 26, color: primaryColor),
          if ((label ?? extension).isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              (label ?? extension).toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Color(0xff5C5C5C),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _attachmentTile({
    required Widget preview,
    required VoidCallback? onRemove,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 9),
      child: SizedBox(
        width: 74,
        child: Stack(
          children: [
            // Tapping opens the attachment: pictures full screen, PDFs
            // and documents in the device's own viewer. It never reopens
            // the file picker; that is the Add tile's job.
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Container(
                    decoration: BoxDecoration(
                      color: fieldColor,
                      border: Border.all(color: borderColor.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: preview,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 13, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addMoreTile(bool isSaving) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isSaving || _isPickingFiles ? null : _pickAttachments,
      child: SizedBox(
        width: 74,
        child: DottedTileBorder(
          color: borderColor,
          child: Center(
            child: _isPickingFiles
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primaryColor,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 22, color: primaryColor),
                      const SizedBox(height: 3),
                      const Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xff5C5C5C),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _voiceWidget(bool isSaving) {
    switch (voiceState) {
      case VoiceState.idle:
        return GestureDetector(
          onTap: isSaving ? null : _startRecording,
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: fieldColor,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Text(
                  'Record Your Voice',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const Spacer(),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isSaving ? Colors.grey : Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),
        );

      case VoiceState.recording:
        return Container(
          height: 50,
          decoration: BoxDecoration(
            color: fieldColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xffB9B7FF), width: 1.3),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              const Icon(Icons.mic, size: 18, color: Colors.red),
              const SizedBox(width: 10),
              Expanded(
                child: CustomPaint(
                  painter: WaveformPainter(color: primaryColor),
                  child: const SizedBox(height: 34),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDuration(_recordingDuration),
                style: const TextStyle(fontSize: 10),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: isSaving ? null : _stopRecording,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.stop, color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        );

      case VoiceState.recorded:
        final Duration displayedDuration = _playbackDuration > Duration.zero
            ? _playbackDuration
            : _recordingDuration;

        final double progress = displayedDuration.inMilliseconds > 0
            ? (_playbackPosition.inMilliseconds /
                      displayedDuration.inMilliseconds)
                  .clamp(0.0, 1.0)
            : 0;

        return Container(
          height: 55,
          decoration: BoxDecoration(
            color: fieldColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              GestureDetector(
                onTap: isSaving ? null : _toggleAudioPlayback,
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 25,
                  color: const Color(0xff20345C),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 3,
                      color: primaryColor,
                      backgroundColor: primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${_formatDuration(_playbackPosition)} / '
                        '${_formatDuration(displayedDuration)}',
                        style: const TextStyle(fontSize: 9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: isSaving ? null : _deleteRecording,
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 19,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        );
    }
  }
}

/// Dashed outline for the small "Add" tile.
/// Full screen look at one attachment picture. Pinch or double tap to
/// zoom, tap the backdrop or the close button to come back.
class FullScreenImageViewer extends StatelessWidget {
  final ImageProvider image;
  final String title;

  const FullScreenImageViewer({
    super.key,
    required this.image,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).maybePop();
                },
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Center(
                    child: Image(
                      image: image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) {
                        return const Icon(
                          Icons.broken_image_outlined,
                          color: Colors.white54,
                          size: 44,
                        );
                      },
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;

                        return const SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).maybePop();
                    },
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 19,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DottedTileBorder extends StatelessWidget {
  final Color color;
  final Widget child;

  const DottedTileBorder({super.key, required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TileDashPainter(color: color),
      child: child,
    );
  }
}

class _TileDashPainter extends CustomPainter {
  final Color color;

  const _TileDashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 5;
    const double dashSpace = 4;

    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(7),
        ),
      );

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final double end = min(distance + dashWidth, metric.length);

        canvas.drawPath(metric.extractPath(distance, end), paint);

        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TileDashPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 8;
    const double dashSpace = 6;

    final Paint paint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(8),
        ),
      );

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final double end = min(distance + dashWidth, metric.length);

        final Path extractedPath = metric.extractPath(distance, end);

        canvas.drawPath(extractedPath, paint);

        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return false;
  }
}

class WaveformPainter extends CustomPainter {
  final Color color;

  WaveformPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withOpacity(0.8)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final Random random = Random(4);

    double x = 0;

    while (x < size.width) {
      final double barHeight = 8 + random.nextDouble() * 24;

      final double y1 = size.height / 2 - barHeight / 2;
      final double y2 = size.height / 2 + barHeight / 2;

      canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);

      x += 5;
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:ui';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:cristalteacher/core/appdata/appdata.dart';
// import 'package:cristalteacher/core/utils/text_stylepicker.dart.dart';
// import 'package:cristalteacher/features/diary/domain/parameters/save_diary_parameter.dart';
// import 'package:cristalteacher/features/diary/domain/parameters/update_diary_parameter.dart';
// import 'package:cristalteacher/features/diary/presentation/cubit/diary_cubit.dart';
// import 'package:cristalteacher/features/diary/presentation/screens/diary_screen.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';
// import 'package:url_launcher/url_launcher.dart';

// enum VoiceState { idle, recording, recorded }

// class SelectedDiaryFile {
//   final String name;
//   final String extension;
//   final Uint8List bytes;
//   final int size;

//   const SelectedDiaryFile({
//     required this.name,
//     required this.extension,
//     required this.bytes,
//     required this.size,
//   });

//   String get mimeType {
//     switch (extension.toLowerCase()) {
//       case 'pdf':
//         return 'application/pdf';
//       case 'doc':
//         return 'application/msword';
//       case 'docx':
//         return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
//       case 'jpg':
//       case 'jpeg':
//         return 'image/jpeg';
//       case 'png':
//         return 'image/png';
//       case 'mp3':
//         return 'audio/mpeg';
//       default:
//         return 'application/octet-stream';
//     }
//   }

//   String get dataUri {
//     return 'data:$mimeType;base64,${base64Encode(bytes)}';
//   }
// }

// class SelectYourClassScreen extends StatefulWidget {
//   /// Null when creating. Set when the diary is being edited.
//   final int? diaryId;

//   final int standardId;
//   final String standardName;

//   final int divisionId;
//   final String divisionName;

//   final int subjectId;
//   final String subjectName;

//   final DateTime diaryDate;
//   final DateTime dueDate;

//   final bool isFavourite;

//   /// Optional values already loaded by CreateDiaryScreen. Used as the
//   /// immediate prefill so the fields are never blank; the API response
//   /// overwrites them when it lands.
//   final String initialTitle;
//   final String initialDescription;
//   final List<String> existingFiles;

//   const SelectYourClassScreen({
//     super.key,
//     this.diaryId,
//     required this.standardId,
//     required this.standardName,
//     required this.divisionId,
//     required this.divisionName,
//     required this.subjectId,
//     required this.subjectName,
//     required this.diaryDate,
//     required this.dueDate,
//     required this.isFavourite,
//     this.initialTitle = '',
//     this.initialDescription = '',
//     this.existingFiles = const <String>[],
//   });

//   @override
//   State<SelectYourClassScreen> createState() => _SelectYourClassScreenState();
// }

// class _SelectYourClassScreenState extends State<SelectYourClassScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   final AudioRecorder _audioRecorder = AudioRecorder();
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   final List<SelectedDiaryFile> _selectedFiles = [];

//   /// Attachment URLs already stored on the server. Whatever is left here
//   /// is sent back untouched, so an update does not wipe them.
//   final List<String> _existingFiles = [];

//   /// True while fetchDiaryUpdateListing is in flight.
//   bool _isLoadingDiary = false;

//   // Size + colour per field, driven by the shared picker.
//   EditorTextStyle _titleStyle = EditorTextStyle.initial;
//   EditorTextStyle _descriptionStyle = EditorTextStyle.initial;

//   VoiceState voiceState = VoiceState.idle;

//   Timer? _recordingTimer;

//   Duration _recordingDuration = Duration.zero;
//   Duration _playbackPosition = Duration.zero;
//   Duration _playbackDuration = Duration.zero;

//   String? _recordedAudioPath;
//   bool _isPlaying = false;
//   bool _isPickingFiles = false;

//   static const int _maximumFileSize = 10 * 1024 * 1024;

//   static const List<String> _allowedExtensions = [
//     'pdf',
//     'doc',
//     'docx',
//     'jpg',
//     'jpeg',
//     'png',
//     'mp3',
//   ];

//   /// Extensions shown as a picture instead of an icon.
//   static const List<String> _imageExtensions = ['jpg', 'jpeg', 'png'];

//   final Color bgColor = const Color(0xffFBF7FF);
//   final Color fieldColor = const Color(0xffEEF4FF);
//   final Color primaryColor = const Color(0xff9B73E6);
//   final Color borderColor = const Color(0xffB7C4D6);

//   /// Palette handed to the shared input field / picker.
//   EditorStyleTheme get _styleTheme {
//     return EditorStyleTheme(
//       accentColor: primaryColor,
//       fillColor: fieldColor,
//       borderColor: borderColor,
//     );
//   }

//   bool get isEditMode => widget.diaryId != null;

//   @override
//   void initState() {
//     super.initState();

//     _configureAudioPlayer();

//     // Immediate prefill from whatever the previous screen already had.
//     _titleController.text = EditorTextStyle.stripHtml(widget.initialTitle);
//     _descriptionController.text = EditorTextStyle.stripHtml(
//       widget.initialDescription,
//     );

//     _titleStyle = EditorTextStyle.fromHtml(widget.initialTitle);
//     _descriptionStyle = EditorTextStyle.fromHtml(widget.initialDescription);

//     _existingFiles.addAll(
//       widget.existingFiles.where((file) => file.trim().isNotEmpty),
//     );

//     if (isEditMode) {
//       _isLoadingDiary = true;

//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (!mounted) return;

//         _fetchDiaryForEdit();
//       });
//     }

//     debugPrint('==========================================');
//     debugPrint('SELECTED DIARY DETAILS');
//     debugPrint(
//       'Mode        : ${isEditMode ? 'EDIT (${widget.diaryId})' : 'CREATE'}',
//     );
//     debugPrint('Standard    : ${widget.standardName} (${widget.standardId})');
//     debugPrint('Division    : ${widget.divisionName} (${widget.divisionId})');
//     debugPrint('Subject     : ${widget.subjectName} (${widget.subjectId})');
//     debugPrint('Diary Date  : ${formatApiDate(widget.diaryDate)}');
//     debugPrint('Due Date    : ${formatApiDate(widget.dueDate)}');
//     debugPrint('Is Favourite: ${widget.isFavourite}');
//     debugPrint('Employee ID : ${AppData.employeeId}');
//     debugPrint('==========================================');
//   }

//   void _fetchDiaryForEdit() {
//     debugPrint('==========================================');
//     debugPrint('LOADING DIARY CONTENT FOR EDIT');
//     debugPrint('Diary ID: ${widget.diaryId}');
//     debugPrint('==========================================');

//     context.read<DiaryCubit>().fetchDiaryUpdateListing(widget.diaryId!);
//   }

//   /// Puts the fetched diary onto the form.
//   void _applyDiaryDetails(dynamic data) {
//     final String rawTitle = data.diaryTitle?.toString() ?? '';
//     final String rawDescription = data.description?.toString() ?? '';

//     final String title = EditorTextStyle.stripHtml(rawTitle);
//     final String description = EditorTextStyle.stripHtml(rawDescription);

//     final List<String> files = List<String>.from(
//       data.files ?? const [],
//     ).where((file) => file.trim().isNotEmpty).toList();

//     setState(() {
//       _titleController.text = title;
//       _descriptionController.text = description;

//       // Restore the size / colour the diary was saved with.
//       _titleStyle = EditorTextStyle.fromHtml(rawTitle);
//       _descriptionStyle = EditorTextStyle.fromHtml(rawDescription);

//       _existingFiles
//         ..clear()
//         ..addAll(files);
//     });

//     debugPrint('==========================================');
//     debugPrint('EDIT CONTENT APPLIED');
//     debugPrint('Title      : $title');
//     debugPrint('Description: $description');
//     debugPrint('Title style: $_titleStyle');
//     debugPrint('Desc style : $_descriptionStyle');
//     debugPrint('Files      : ${files.length}');
//     debugPrint('==========================================');
//   }

//   void _configureAudioPlayer() {
//     _audioPlayer.onDurationChanged.listen((duration) {
//       if (!mounted) return;

//       setState(() {
//         _playbackDuration = duration;
//       });
//     });

//     _audioPlayer.onPositionChanged.listen((position) {
//       if (!mounted) return;

//       setState(() {
//         _playbackPosition = position;
//       });
//     });

//     _audioPlayer.onPlayerComplete.listen((_) {
//       if (!mounted) return;

//       setState(() {
//         _isPlaying = false;
//         _playbackPosition = Duration.zero;
//       });
//     });

//     _audioPlayer.onPlayerStateChanged.listen((state) {
//       if (!mounted) return;

//       setState(() {
//         _isPlaying = state == PlayerState.playing;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _recordingTimer?.cancel();

//     _titleController.dispose();
//     _descriptionController.dispose();

//     _audioRecorder.dispose();
//     _audioPlayer.dispose();

//     super.dispose();
//   }

//   String formatApiDate(DateTime date) {
//     final String year = date.year.toString();
//     final String month = date.month.toString().padLeft(2, '0');
//     final String day = date.day.toString().padLeft(2, '0');

//     return '$year-$month-$day';
//   }

//   String _formatDuration(Duration duration) {
//     final int minutes = duration.inMinutes;
//     final int seconds = duration.inSeconds.remainder(60);

//     return '${minutes.toString().padLeft(2, '0')}:'
//         '${seconds.toString().padLeft(2, '0')}';
//   }

//   IconData _getFileIcon(String extension) {
//     switch (extension.toLowerCase()) {
//       case 'pdf':
//         return Icons.picture_as_pdf_outlined;
//       case 'doc':
//       case 'docx':
//         return Icons.description_outlined;
//       case 'jpg':
//       case 'jpeg':
//       case 'png':
//         return Icons.image_outlined;
//       case 'mp3':
//       case 'm4a':
//       case 'aac':
//       case 'wav':
//         return Icons.audio_file_outlined;
//       default:
//         return Icons.insert_drive_file_outlined;
//     }
//   }

//   bool _isImage(String extension) {
//     return _imageExtensions.contains(extension.toLowerCase());
//   }

//   String _fileNameFromUrl(String url) {
//     final String cleaned = url.trim().replaceAll('\\', '/');
//     final Uri? uri = Uri.tryParse(cleaned);
//     final List<String> segments = uri?.pathSegments ?? const [];

//     if (segments.isNotEmpty) {
//       return Uri.decodeComponent(segments.last);
//     }

//     return 'Attachment';
//   }

//   String _extensionFromUrl(String url) {
//     final String name = _fileNameFromUrl(url);
//     final int dotIndex = name.lastIndexOf('.');

//     if (dotIndex == -1) {
//       return '';
//     }

//     return name.substring(dotIndex + 1).toLowerCase();
//   }

//   Future<void> _pickAttachments() async {
//     if (_isPickingFiles) return;

//     setState(() {
//       _isPickingFiles = true;
//     });

//     try {
//       final FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowMultiple: true,
//         allowedExtensions: _allowedExtensions,
//         withData: true,
//       );

//       if (result == null) {
//         return;
//       }

//       final List<SelectedDiaryFile> newFiles = [];

//       for (final PlatformFile platformFile in result.files) {
//         final String extension = (platformFile.extension ?? '').toLowerCase();

//         if (!_allowedExtensions.contains(extension)) {
//           _showMessage('${platformFile.name} is not a supported file');
//           continue;
//         }

//         if (platformFile.size > _maximumFileSize) {
//           _showMessage('${platformFile.name} exceeds the 10 MB limit');
//           continue;
//         }

//         Uint8List? bytes = platformFile.bytes;

//         if (bytes == null && platformFile.path != null) {
//           bytes = await File(platformFile.path!).readAsBytes();
//         }

//         if (bytes == null || bytes.isEmpty) {
//           _showMessage('Unable to read ${platformFile.name}');
//           continue;
//         }

//         final bool alreadySelected = _selectedFiles.any(
//           (file) =>
//               file.name == platformFile.name && file.size == platformFile.size,
//         );

//         final bool duplicatedInCurrentSelection = newFiles.any(
//           (file) =>
//               file.name == platformFile.name && file.size == platformFile.size,
//         );

//         if (alreadySelected || duplicatedInCurrentSelection) {
//           continue;
//         }

//         newFiles.add(
//           SelectedDiaryFile(
//             name: platformFile.name,
//             extension: extension,
//             bytes: bytes,
//             size: platformFile.size,
//           ),
//         );
//       }

//       if (!mounted) return;

//       setState(() {
//         _selectedFiles.addAll(newFiles);
//       });

//       if (newFiles.isNotEmpty) {
//         _showMessage(
//           '${newFiles.length} attachment'
//           '${newFiles.length == 1 ? '' : 's'} selected',
//         );
//       }
//     } catch (error, stackTrace) {
//       debugPrint('Attachment selection error: $error');
//       debugPrintStack(stackTrace: stackTrace);

//       _showMessage('Unable to select attachments');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isPickingFiles = false;
//         });
//       }
//     }
//   }

//   void _removeAttachment(int index) {
//     if (index < 0 || index >= _selectedFiles.length) {
//       return;
//     }

//     setState(() {
//       _selectedFiles.removeAt(index);
//     });
//   }

//   /// Removing an existing attachment only drops it from the list that is
//   /// sent back, which is what deletes it on the server.
//   void _removeExistingAttachment(int index) {
//     if (index < 0 || index >= _existingFiles.length) {
//       return;
//     }

//     setState(() {
//       _existingFiles.removeAt(index);
//     });
//   }

//   Future<void> _startRecording() async {
//     try {
//       await _audioPlayer.stop();

//       final bool hasPermission = await _audioRecorder.hasPermission();

//       if (!hasPermission) {
//         _showMessage('Microphone permission is required to record audio');
//         return;
//       }

//       final Directory temporaryDirectory = await getTemporaryDirectory();

//       final String audioPath =
//           '${temporaryDirectory.path}/diary_voice_'
//           '${DateTime.now().millisecondsSinceEpoch}.m4a';

//       await _audioRecorder.start(
//         const RecordConfig(
//           encoder: AudioEncoder.aacLc,
//           bitRate: 128000,
//           sampleRate: 44100,
//         ),
//         path: audioPath,
//       );

//       _recordingTimer?.cancel();

//       if (!mounted) return;

//       setState(() {
//         _recordedAudioPath = audioPath;
//         _recordingDuration = Duration.zero;
//         _playbackPosition = Duration.zero;
//         _playbackDuration = Duration.zero;
//         _isPlaying = false;
//         voiceState = VoiceState.recording;
//       });

//       _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//         if (!mounted) return;

//         setState(() {
//           _recordingDuration += const Duration(seconds: 1);
//         });
//       });
//     } catch (error, stackTrace) {
//       debugPrint('Start recording error: $error');
//       debugPrintStack(stackTrace: stackTrace);

//       _showMessage('Unable to start voice recording');

//       if (mounted) {
//         setState(() {
//           voiceState = VoiceState.idle;
//         });
//       }
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       _recordingTimer?.cancel();
//       _recordingTimer = null;

//       final String? path = await _audioRecorder.stop();

//       if (path == null) {
//         throw Exception('Recording path was not returned');
//       }

//       final File audioFile = File(path);

//       if (!await audioFile.exists()) {
//         throw Exception('Recorded audio file does not exist');
//       }

//       final int audioSize = await audioFile.length();

//       if (audioSize <= 0) {
//         throw Exception('Recorded audio file is empty');
//       }

//       if (!mounted) return;

//       setState(() {
//         _recordedAudioPath = path;
//         _playbackDuration = _recordingDuration;
//         _playbackPosition = Duration.zero;
//         voiceState = VoiceState.recorded;
//       });
//     } catch (error, stackTrace) {
//       debugPrint('Stop recording error: $error');
//       debugPrintStack(stackTrace: stackTrace);

//       _showMessage('Unable to save voice recording');

//       if (mounted) {
//         setState(() {
//           _recordedAudioPath = null;
//           voiceState = VoiceState.idle;
//         });
//       }
//     }
//   }

//   Future<void> _toggleAudioPlayback() async {
//     final String? audioPath = _recordedAudioPath;

//     if (audioPath == null || audioPath.isEmpty) {
//       _showMessage('Recorded audio is not available');
//       return;
//     }

//     try {
//       if (_isPlaying) {
//         await _audioPlayer.pause();
//         return;
//       }

//       final PlayerState playerState = _audioPlayer.state;

//       if (playerState == PlayerState.paused) {
//         await _audioPlayer.resume();
//       } else {
//         await _audioPlayer.play(DeviceFileSource(audioPath));
//       }
//     } catch (error, stackTrace) {
//       debugPrint('Audio playback error: $error');
//       debugPrintStack(stackTrace: stackTrace);

//       _showMessage('Unable to play the recorded audio');
//     }
//   }

//   Future<void> _deleteRecording() async {
//     try {
//       _recordingTimer?.cancel();
//       _recordingTimer = null;

//       if (await _audioRecorder.isRecording()) {
//         await _audioRecorder.stop();
//       }

//       await _audioPlayer.stop();

//       final String? audioPath = _recordedAudioPath;

//       if (audioPath != null && audioPath.isNotEmpty) {
//         final File audioFile = File(audioPath);

//         if (await audioFile.exists()) {
//           await audioFile.delete();
//         }
//       }
//     } catch (error) {
//       debugPrint('Delete recording error: $error');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _recordedAudioPath = null;
//           _recordingDuration = Duration.zero;
//           _playbackDuration = Duration.zero;
//           _playbackPosition = Duration.zero;
//           _isPlaying = false;
//           voiceState = VoiceState.idle;
//         });
//       }
//     }
//   }

//   /// Kept server URLs first, then newly picked files, then the recording.
//   Future<List<String>> _buildApiFiles() async {
//     final List<String> files = [
//       ..._existingFiles,
//       ..._selectedFiles.map((file) => file.dataUri),
//     ];

//     final String? recordedAudioPath = _recordedAudioPath;

//     if (recordedAudioPath != null &&
//         recordedAudioPath.isNotEmpty &&
//         voiceState == VoiceState.recorded) {
//       final File audioFile = File(recordedAudioPath);

//       if (await audioFile.exists()) {
//         final Uint8List audioBytes = await audioFile.readAsBytes();

//         if (audioBytes.isNotEmpty) {
//           files.add('data:audio/mp4;base64,${base64Encode(audioBytes)}');
//         }
//       }
//     }

//     return files;
//   }

//   /// Runs the create or the update request, depending on diaryId.
//   Future<void> _saveDiary() async {
//     FocusScope.of(context).unfocus();

//     final String title = _titleController.text.trim();
//     final String description = _descriptionController.text.trim();

//     debugPrint('');
//     debugPrint('==================================================');
//     debugPrint('${isEditMode ? 'UPDATE' : 'SAVE'} DIARY BUTTON PRESSED');
//     debugPrint('==================================================');
//     debugPrint('Diary ID      : ${widget.diaryId}');
//     debugPrint('Standard ID   : ${widget.standardId}');
//     debugPrint('Division ID   : ${widget.divisionId}');
//     debugPrint('Subject ID    : ${widget.subjectId}');
//     debugPrint('Title         : $title');
//     debugPrint('Description   : $description');
//     debugPrint('Title style   : $_titleStyle');
//     debugPrint('Desc style    : $_descriptionStyle');
//     debugPrint('Voice State   : $voiceState');
//     debugPrint('Kept files    : ${_existingFiles.length}');
//     debugPrint('New files     : ${_selectedFiles.length}');

//     if (voiceState == VoiceState.recording) {
//       _showMessage('Please stop the voice recording before saving');
//       return;
//     }

//     if (title.isEmpty) {
//       _showMessage('Please enter Heading or Title');
//       return;
//     }

//     if (description.isEmpty) {
//       _showMessage('Please enter Description');
//       return;
//     }

//     if (AppData.accYear == null) {
//       _showMessage('Academic year is not available');
//       return;
//     }

//     if (AppData.employeeId == null) {
//       _showMessage('Employee ID is not available');
//       return;
//     }

//     // Size / colour travel with the text as inline HTML.
//     final String styledTitle = _titleStyle.wrapHtml(title);
//     final String styledDescription = _descriptionStyle.wrapHtml(description);

//     try {
//       final List<String> apiFiles = await _buildApiFiles();

//       debugPrint('Total files sent: ${apiFiles.length}');

//       if (!mounted) return;

//       // ---------------- UPDATE ----------------
//       if (isEditMode) {
//         final UpdateDiaryParameter request = UpdateDiaryParameter(
//           accYear: AppData.accYear!,
//           standardId: widget.standardId,
//           divisionId: widget.divisionId,
//           subjectId: widget.subjectId,
//           employeeId: AppData.employeeId!,
//           diaryType: null,
//           diaryTitle: styledTitle,
//           description: styledDescription,
//           diaryDate: formatApiDate(widget.diaryDate),
//           dueDate: formatApiDate(widget.dueDate),
//           isActive: true,
//           isFavourite: widget.isFavourite,
//           branchId: AppData.branchId ?? 1,
//           modifiedUser: AppData.userId.toString(),
//           files: apiFiles,
//           videoUrl: '',
//         );

//         debugPrint('');
//         debugPrint('==================================================');
//         debugPrint('UPDATE DIARY REQUEST');
//         debugPrint('==================================================');

//         _printRequestJson(request.toJson());

//         await context.read<DiaryCubit>().updateDiary(request, widget.diaryId!);
//         return;
//       }

//       // ---------------- CREATE ----------------
//       final SaveDiaryParameter request = SaveDiaryParameter(
//         accYear: AppData.accYear!,
//         standardId: widget.standardId,
//         divisionId: widget.divisionId,
//         subjectId: widget.subjectId,
//         employeeId: AppData.employeeId!,
//         diaryType: null,
//         diaryTitle: styledTitle,
//         description: styledDescription,
//         diaryDate: formatApiDate(widget.diaryDate),
//         dueDate: formatApiDate(widget.dueDate),
//         isActive: true,
//         isFavourite: widget.isFavourite,
//         branchId: AppData.branchId ?? 1,
//         createdUser: AppData.userId.toString(),
//         files: apiFiles,
//         videoUrl: '',
//       );

//       debugPrint('');
//       debugPrint('==================================================');
//       debugPrint('SAVE DIARY REQUEST');
//       debugPrint('==================================================');

//       _printRequestJson(request.toJson());

//       await context.read<DiaryCubit>().saveDiary(request);
//     } catch (error, stackTrace) {
//       debugPrint('Prepare diary request error: $error');
//       debugPrintStack(stackTrace: stackTrace);

//       _showMessage('Unable to prepare attachments');
//     }
//   }

//   /// Prints the request without dumping whole base64 payloads.
//   void _printRequestJson(Map<String, dynamic> requestJson) {
//     requestJson.forEach((key, value) {
//       if (key == 'files') {
//         final List<dynamic> files = value is List ? value : [];

//         debugPrint('$key : ${files.length} file(s)');

//         for (int i = 0; i < files.length; i++) {
//           final String file = files[i].toString();

//           debugPrint(
//             '  File ${i + 1}: '
//             '${file.length > 40 ? file.substring(0, 40) : file}',
//           );
//         }
//       } else {
//         debugPrint('$key : $value');
//       }
//     });

//     debugPrint('==================================================');
//   }

//   /// Shared cleanup + navigation for both create and update success.
//   Future<void> _onDiarySubmitted(String apiMessage) async {
//     _showMessage(
//       apiMessage.trim().isNotEmpty
//           ? apiMessage
//           : isEditMode
//           ? 'Diary updated successfully'
//           : 'Diary saved successfully',
//     );

//     _titleController.clear();
//     _descriptionController.clear();
//     _selectedFiles.clear();
//     _existingFiles.clear();

//     await _deleteRecording();

//     if (!mounted) return;

//     if (isEditMode) {
//       // diary -> create -> details, so two pops land back on the list the
//       // user was already looking at, with its filter and date range intact.
//       // Its edit button awaits this push and reloads the list itself.
//       Navigator.of(context)
//         ..pop()
//         ..pop();

//       return;
//     }

//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (_) => const DiaryTypeScreen()),

//       // Keeps the dashboard and removes the diary creation screens.
//       (route) => route.isFirst,
//     );
//   }

//   void _showMessage(String message) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
//       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<DiaryCubit, DiaryState>(
//       listenWhen: (previous, current) {
//         return current is SaveDiarySuccess ||
//             current is UpdateDiarySuccess ||
//             current is UpdateDiaryFailure ||
//             current is FetchDiaryUpdateListingSuccess ||
//             current is FetchDiaryUpdateListingFailure ||
//             current is DiaryFailure;
//       },
//       listener: (context, state) async {
//         // ---------- diary loaded for editing ----------
//         if (state is FetchDiaryUpdateListingSuccess) {
//           setState(() {
//             _isLoadingDiary = false;
//           });

//           final data = state.response.data;

//           if (data == null) {
//             _showMessage('Diary details are not available');
//             return;
//           }

//           _applyDiaryDetails(data);
//           return;
//         }

//         if (state is FetchDiaryUpdateListingFailure) {
//           setState(() {
//             _isLoadingDiary = false;
//           });

//           _showMessage(state.message);
//           return;
//         }

//         // ---------- diary created ----------
//         if (state is SaveDiarySuccess) {
//           await _onDiarySubmitted(state.response.message?.toString() ?? '');
//           return;
//         }

//         // ---------- diary updated ----------
//         if (state is UpdateDiarySuccess) {
//           await _onDiarySubmitted(state.response.message?.toString() ?? '');
//           return;
//         }

//         if (state is UpdateDiaryFailure) {
//           _showMessage(state.message);
//           return;
//         }

//         if (state is DiaryFailure) {
//           _showMessage(state.message);
//         }
//       },
//       builder: (context, state) {
//         final bool isSaving =
//             state is SaveDiaryLoading || state is UpdateDiaryLoading;

//         return PopScope(
//           canPop: !isSaving && voiceState != VoiceState.recording,
//           child: Scaffold(
//             backgroundColor: bgColor,
//             body: SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 18),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 12),
//                     _buildHeader(isSaving),
//                     const SizedBox(height: 28),
//                     Expanded(
//                       child: _isLoadingDiary
//                           ? Center(
//                               child: CircularProgressIndicator(
//                                 color: primaryColor,
//                               ),
//                             )
//                           : SingleChildScrollView(
//                               keyboardDismissBehavior:
//                                   ScrollViewKeyboardDismissBehavior.onDrag,
//                               child: Column(
//                                 children: [
//                                   StyledInputField(
//                                     controller: _titleController,
//                                     hint: 'Heading Or Title',
//                                     minHeight: 44,
//                                     enabled: !isSaving,
//                                     style: _titleStyle,
//                                     theme: _styleTheme,
//                                     onStyleChanged: (style) {
//                                       setState(() {
//                                         _titleStyle = style;
//                                       });
//                                     },
//                                   ),
//                                   const SizedBox(height: 14),
//                                   StyledInputField(
//                                     controller: _descriptionController,
//                                     hint: 'Description',
//                                     minHeight: 118,
//                                     maxLines: 5,
//                                     enabled: !isSaving,
//                                     style: _descriptionStyle,
//                                     theme: _styleTheme,
//                                     onStyleChanged: (style) {
//                                       setState(() {
//                                         _descriptionStyle = style;
//                                       });
//                                     },
//                                   ),
//                                   const SizedBox(height: 14),

//                                   // Picked images and files preview inside
//                                   // the box itself.
//                                   _attachmentBox(isSaving),

//                                   const SizedBox(height: 10),
//                                   const Row(
//                                     children: [
//                                       Icon(
//                                         Icons.info,
//                                         size: 15,
//                                         color: Colors.grey,
//                                       ),
//                                       SizedBox(width: 5),
//                                       Expanded(
//                                         child: Text(
//                                           'Allow Pdf, Doc, Docx, Jpg, Png, Mp3. Maximum 10 MB each.',
//                                           style: TextStyle(
//                                             fontSize: 11,
//                                             color: Color(0xff5C5C5C),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 12),
//                                   _voiceWidget(isSaving),
//                                   const SizedBox(height: 24),
//                                 ],
//                               ),
//                             ),
//                     ),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 48,
//                       child: ElevatedButton(
//                         onPressed: isSaving || _isLoadingDiary
//                             ? null
//                             : _saveDiary,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: primaryColor,
//                           disabledBackgroundColor: primaryColor.withOpacity(
//                             0.6,
//                           ),
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                         ),
//                         child: isSaving
//                             ? const SizedBox(
//                                 width: 21,
//                                 height: 21,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2.2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : Text(
//                                 isEditMode ? 'Update' : 'Save',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildHeader(bool isSaving) {
//     final bool locked = isSaving || voiceState == VoiceState.recording;

//     return Row(
//       children: [
//         GestureDetector(
//           onTap: locked
//               ? null
//               : () {
//                   Navigator.maybePop(context);
//                 },
//           child: Icon(
//             Icons.arrow_back,
//             size: 22,
//             color: locked ? Colors.grey : Colors.black,
//           ),
//         ),
//         Expanded(
//           child: Center(
//             child: Text(
//               isEditMode ? 'Edit Diary' : 'Select Your Class',
//               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//             ),
//           ),
//         ),
//         const SizedBox(width: 22),
//       ],
//     );
//   }

//   /// Empty: the upload prompt. With attachments: a row of thumbnails inside
//   /// the same dashed box, images shown as pictures.
//   Widget _attachmentBox(bool isSaving) {
//     final bool hasFiles =
//         _existingFiles.isNotEmpty || _selectedFiles.isNotEmpty;

//     return CustomPaint(
//       painter: DashedBorderPainter(),
//       child: SizedBox(
//         width: double.infinity,
//         height: 105,
//         child: hasFiles
//             ? _buildAttachmentPreviews(isSaving)
//             : _buildEmptyAttachment(isSaving),
//       ),
//     );
//   }

//   Widget _buildEmptyAttachment(bool isSaving) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: isSaving || _isPickingFiles ? null : _pickAttachments,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if (_isPickingFiles)
//             SizedBox(
//               width: 24,
//               height: 24,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: primaryColor,
//               ),
//             )
//           else
//             SvgPicture.asset(
//               'assets/icons/Group (9).svg',
//               width: 24,
//               height: 24,
//               fit: BoxFit.contain,
//             ),
//           const SizedBox(height: 6),
//           Text(
//             _isPickingFiles ? 'Selecting...' : 'Attachment',
//             style: const TextStyle(fontSize: 12, color: Colors.black),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAttachmentPreviews(bool isSaving) {
//     return ListView(
//       scrollDirection: Axis.horizontal,
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//       children: [
//         // Already on the server.
//         for (int index = 0; index < _existingFiles.length; index++)
//           _attachmentTile(
//             preview: _existingFilePreview(_existingFiles[index]),
//             onTap: _isImage(_extensionFromUrl(_existingFiles[index]))
//                 ? () => _openImageViewer(
//                     NetworkImage(_existingFiles[index]),
//                     _fileNameFromUrl(_existingFiles[index]),
//                   )
//                 : () => _openExistingDocument(_existingFiles[index]),
//             onRemove: isSaving ? null : () => _removeExistingAttachment(index),
//           ),

//         // Picked in this session.
//         for (int index = 0; index < _selectedFiles.length; index++)
//           _attachmentTile(
//             preview: _selectedFilePreview(_selectedFiles[index]),
//             onTap: _isImage(_selectedFiles[index].extension)
//                 ? () => _openImageViewer(
//                     MemoryImage(_selectedFiles[index].bytes),
//                     _selectedFiles[index].name,
//                   )
//                 : () => _openSelectedDocument(_selectedFiles[index]),
//             onRemove: isSaving ? null : () => _removeAttachment(index),
//           ),

//         _addMoreTile(isSaving),
//       ],
//     );
//   }

//   /// Shows the tapped attachment on its own screen.
//   void _openImageViewer(ImageProvider image, String title) {
//     Navigator.of(context).push(
//       PageRouteBuilder<void>(
//         pageBuilder: (_, __, ___) {
//           return FullScreenImageViewer(image: image, title: title);
//         },
//         transitionsBuilder: (_, animation, __, child) {
//           return FadeTransition(opacity: animation, child: child);
//         },
//         transitionDuration: const Duration(milliseconds: 180),
//       ),
//     );
//   }

//   /// A PDF or document already on the server. It has a real URL, so the
//   /// device opens it directly.
//   Future<void> _openExistingDocument(String fileUrl) async {
//     final Uri? uri = Uri.tryParse(fileUrl.trim());

//     if (uri == null || !uri.hasScheme) {
//       _showMessage('This attachment cannot be opened');
//       return;
//     }

//     try {
//       final bool opened = await launchUrl(
//         uri,
//         mode: LaunchMode.externalApplication,
//       );

//       if (!opened) {
//         _showMessage('No app available to open this file');
//       }
//     } catch (error, stackTrace) {
//       debugPrint('Open attachment error: $error');
//       debugPrintStack(stackTrace: stackTrace);

//       _showMessage('Unable to open this attachment');
//     }
//   }

//   /// A PDF or document picked in this session. It only exists as bytes in
//   /// memory, so it is written to the temp folder before being handed to
//   /// whichever app the device uses for that type.
//   Future<void> _openSelectedDocument(SelectedDiaryFile file) async {
//     try {
//       final Directory temporaryDirectory = await getTemporaryDirectory();

//       final Directory attachmentDirectory = Directory(
//         '${temporaryDirectory.path}/diary_attachments',
//       );

//       if (!await attachmentDirectory.exists()) {
//         await attachmentDirectory.create(recursive: true);
//       }

//       final File target = File('${attachmentDirectory.path}/${file.name}');

//       await target.writeAsBytes(file.bytes, flush: true);

//       final OpenResult result = await OpenFilex.open(
//         target.path,
//         type: file.mimeType,
//       );

//       if (result.type != ResultType.done) {
//         _showMessage('No app available to open ${file.name}');
//       }
//     } catch (error, stackTrace) {
//       debugPrint('Open picked attachment error: $error');
//       debugPrintStack(stackTrace: stackTrace);

//       _showMessage('Unable to open ${file.name}');
//     }
//   }

//   /// Server attachment: the picture itself for images, an icon otherwise.
//   Widget _existingFilePreview(String fileUrl) {
//     final String extension = _extensionFromUrl(fileUrl);

//     if (_isImage(extension)) {
//       return Image.network(
//         fileUrl,
//         fit: BoxFit.cover,
//         errorBuilder: (_, __, ___) => _fileIconPreview(extension),
//         loadingBuilder: (context, child, progress) {
//           if (progress == null) return child;

//           return Center(
//             child: SizedBox(
//               width: 18,
//               height: 18,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: primaryColor,
//               ),
//             ),
//           );
//         },
//       );
//     }

//     return _fileIconPreview(extension);
//   }

//   /// Newly picked attachment: drawn straight from the bytes already in
//   /// memory, so no temp file is needed.
//   Widget _selectedFilePreview(SelectedDiaryFile file) {
//     if (_isImage(file.extension)) {
//       return Image.memory(
//         file.bytes,
//         fit: BoxFit.cover,
//         errorBuilder: (_, __, ___) => _fileIconPreview(file.extension),
//       );
//     }

//     return _fileIconPreview(file.extension, label: file.extension);
//   }

//   Widget _fileIconPreview(String extension, {String? label}) {
//     return Container(
//       color: fieldColor,
//       alignment: Alignment.center,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(_getFileIcon(extension), size: 26, color: primaryColor),
//           if ((label ?? extension).isNotEmpty) ...[
//             const SizedBox(height: 4),
//             Text(
//               (label ?? extension).toUpperCase(),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 fontSize: 9,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xff5C5C5C),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _attachmentTile({
//     required Widget preview,
//     required VoidCallback? onRemove,
//     VoidCallback? onTap,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 9),
//       child: SizedBox(
//         width: 74,
//         child: Stack(
//           children: [
//             // Tapping opens the attachment: pictures full screen, PDFs
//             // and documents in the device's own viewer. It never reopens
//             // the file picker; that is the Add tile's job.
//             Positioned.fill(
//               child: GestureDetector(
//                 behavior: HitTestBehavior.opaque,
//                 onTap: onTap,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(7),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: fieldColor,
//                       border: Border.all(color: borderColor.withOpacity(0.6)),
//                       borderRadius: BorderRadius.circular(7),
//                     ),
//                     child: preview,
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 2,
//               right: 2,
//               child: GestureDetector(
//                 onTap: onRemove,
//                 child: Container(
//                   width: 20,
//                   height: 20,
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.55),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.close, size: 13, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _addMoreTile(bool isSaving) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: isSaving || _isPickingFiles ? null : _pickAttachments,
//       child: SizedBox(
//         width: 74,
//         child: DottedTileBorder(
//           color: borderColor,
//           child: Center(
//             child: _isPickingFiles
//                 ? SizedBox(
//                     width: 18,
//                     height: 18,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: primaryColor,
//                     ),
//                   )
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.add, size: 22, color: primaryColor),
//                       const SizedBox(height: 3),
//                       const Text(
//                         'Add',
//                         style: TextStyle(
//                           fontSize: 10,
//                           color: Color(0xff5C5C5C),
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _voiceWidget(bool isSaving) {
//     switch (voiceState) {
//       case VoiceState.idle:
//         return GestureDetector(
//           onTap: isSaving ? null : _startRecording,
//           child: Container(
//             height: 46,
//             decoration: BoxDecoration(
//               color: fieldColor,
//               borderRadius: BorderRadius.circular(7),
//             ),
//             child: Row(
//               children: [
//                 const SizedBox(width: 12),
//                 const Text(
//                   'Record Your Voice',
//                   style: TextStyle(fontSize: 12, color: Colors.black),
//                 ),
//                 const Spacer(),
//                 Container(
//                   width: 38,
//                   height: 38,
//                   decoration: BoxDecoration(
//                     color: isSaving ? Colors.grey : Colors.black,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.mic, color: Colors.white, size: 18),
//                 ),
//                 const SizedBox(width: 6),
//               ],
//             ),
//           ),
//         );

//       case VoiceState.recording:
//         return Container(
//           height: 50,
//           decoration: BoxDecoration(
//             color: fieldColor,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: const Color(0xffB9B7FF), width: 1.3),
//           ),
//           child: Row(
//             children: [
//               const SizedBox(width: 10),
//               const Icon(Icons.mic, size: 18, color: Colors.red),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: CustomPaint(
//                   painter: WaveformPainter(color: primaryColor),
//                   child: const SizedBox(height: 34),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 _formatDuration(_recordingDuration),
//                 style: const TextStyle(fontSize: 10),
//               ),
//               const SizedBox(width: 10),
//               GestureDetector(
//                 onTap: isSaving ? null : _stopRecording,
//                 child: Container(
//                   width: 32,
//                   height: 32,
//                   decoration: BoxDecoration(
//                     color: primaryColor,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.stop, color: Colors.white, size: 16),
//                 ),
//               ),
//               const SizedBox(width: 8),
//             ],
//           ),
//         );

//       case VoiceState.recorded:
//         final Duration displayedDuration = _playbackDuration > Duration.zero
//             ? _playbackDuration
//             : _recordingDuration;

//         final double progress = displayedDuration.inMilliseconds > 0
//             ? (_playbackPosition.inMilliseconds /
//                       displayedDuration.inMilliseconds)
//                   .clamp(0.0, 1.0)
//             : 0;

//         return Container(
//           height: 55,
//           decoration: BoxDecoration(
//             color: fieldColor,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: borderColor),
//           ),
//           child: Row(
//             children: [
//               const SizedBox(width: 10),
//               GestureDetector(
//                 onTap: isSaving ? null : _toggleAudioPlayback,
//                 child: Icon(
//                   _isPlaying ? Icons.pause : Icons.play_arrow,
//                   size: 25,
//                   color: const Color(0xff20345C),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     LinearProgressIndicator(
//                       value: progress,
//                       minHeight: 3,
//                       color: primaryColor,
//                       backgroundColor: primaryColor.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     const SizedBox(height: 5),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         '${_formatDuration(_playbackPosition)} / '
//                         '${_formatDuration(displayedDuration)}',
//                         style: const TextStyle(fontSize: 9),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 12),
//               GestureDetector(
//                 onTap: isSaving ? null : _deleteRecording,
//                 child: const Icon(
//                   Icons.delete_outline,
//                   color: Colors.red,
//                   size: 19,
//                 ),
//               ),
//               const SizedBox(width: 12),
//             ],
//           ),
//         );
//     }
//   }
// }

// /// Dashed outline for the small "Add" tile.
// /// Full screen look at one attachment picture. Pinch or double tap to
// /// zoom, tap the backdrop or the close button to come back.
// class FullScreenImageViewer extends StatelessWidget {
//   final ImageProvider image;
//   final String title;

//   const FullScreenImageViewer({
//     super.key,
//     required this.image,
//     this.title = '',
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: GestureDetector(
//                 behavior: HitTestBehavior.opaque,
//                 onTap: () {
//                   Navigator.of(context).maybePop();
//                 },
//                 child: InteractiveViewer(
//                   minScale: 1,
//                   maxScale: 4,
//                   child: Center(
//                     child: Image(
//                       image: image,
//                       fit: BoxFit.contain,
//                       errorBuilder: (_, __, ___) {
//                         return const Icon(
//                           Icons.broken_image_outlined,
//                           color: Colors.white54,
//                           size: 44,
//                         );
//                       },
//                       loadingBuilder: (context, child, progress) {
//                         if (progress == null) return child;

//                         return const SizedBox(
//                           width: 26,
//                           height: 26,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 10,
//               left: 12,
//               right: 12,
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).maybePop();
//                     },
//                     child: Container(
//                       width: 34,
//                       height: 34,
//                       decoration: const BoxDecoration(
//                         color: Colors.white24,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: 19,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(color: Colors.white, fontSize: 12),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DottedTileBorder extends StatelessWidget {
//   final Color color;
//   final Widget child;

//   const DottedTileBorder({super.key, required this.color, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: _TileDashPainter(color: color),
//       child: child,
//     );
//   }
// }

// class _TileDashPainter extends CustomPainter {
//   final Color color;

//   const _TileDashPainter({required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     const double dashWidth = 5;
//     const double dashSpace = 4;

//     final Paint paint = Paint()
//       ..color = color
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;

//     final Path path = Path()
//       ..addRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromLTWH(0, 0, size.width, size.height),
//           const Radius.circular(7),
//         ),
//       );

//     for (final PathMetric metric in path.computeMetrics()) {
//       double distance = 0;

//       while (distance < metric.length) {
//         final double end = min(distance + dashWidth, metric.length);

//         canvas.drawPath(metric.extractPath(distance, end), paint);

//         distance += dashWidth + dashSpace;
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant _TileDashPainter oldDelegate) {
//     return oldDelegate.color != color;
//   }
// }

// class DashedBorderPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     const double dashWidth = 8;
//     const double dashSpace = 6;

//     final Paint paint = Paint()
//       ..color = Colors.black54
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;

//     final Path path = Path()
//       ..addRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromLTWH(0, 0, size.width, size.height),
//           const Radius.circular(8),
//         ),
//       );

//     for (final PathMetric metric in path.computeMetrics()) {
//       double distance = 0;

//       while (distance < metric.length) {
//         final double end = min(distance + dashWidth, metric.length);

//         final Path extractedPath = metric.extractPath(distance, end);

//         canvas.drawPath(extractedPath, paint);

//         distance += dashWidth + dashSpace;
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
//     return false;
//   }
// }

// class WaveformPainter extends CustomPainter {
//   final Color color;

//   WaveformPainter({required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = color.withOpacity(0.8)
//       ..strokeWidth = 2
//       ..strokeCap = StrokeCap.round;

//     final Random random = Random(4);

//     double x = 0;

//     while (x < size.width) {
//       final double barHeight = 8 + random.nextDouble() * 24;

//       final double y1 = size.height / 2 - barHeight / 2;
//       final double y2 = size.height / 2 + barHeight / 2;

//       canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);

//       x += 5;
//     }
//   }

//   @override
//   bool shouldRepaint(covariant WaveformPainter oldDelegate) {
//     return oldDelegate.color != color;
//   }
// }
