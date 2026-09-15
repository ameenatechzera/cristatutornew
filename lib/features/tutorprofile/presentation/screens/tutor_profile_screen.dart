import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  static const Color primaryColor = Color(0xFF807FD8);
  static const Color backgroundColor = Color(0xFFF8F7FD);
  static const Color iconBackgroundColor = Color(0xFFF0EDFF);
  static const Color dividerColor = Color(0xFFEEECEF);

  int? expandedSectionIndex;

  void _toggleSection(int index) {
    setState(() {
      expandedSectionIndex = expandedSectionIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        toolbarHeight: 62,
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 23),
        ),
        title: const Text(
          'Teacher Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 34),
          child: Column(
            children: [
              _buildMainProfileCard(),
              const SizedBox(height: 16),
              _buildSectionCard(
                index: 0,
                svgAsset: 'assets/icons/Layer 2.svg',
                iconColor: const Color(0xFF653FE4),
                title: 'Personal Information',
                child: _buildPersonalInformation(),
              ),
              _buildSectionCard(
                index: 1,
                svgAsset: 'assets/icons/Group (24).svg',
                iconColor: const Color(0xFF653FE4),
                title: 'Contact Information',
                child: _buildContactInformation(),
              ),
              _buildSectionCard(
                index: 2,
                svgAsset: 'assets/icons/Clip path group (2).svg',
                iconColor: const Color(0xFF653FE4),
                title: 'Employment & Location Details',
                child: _buildEmploymentInformation(),
              ),
              _buildSectionCard(
                index: 3,
                svgAsset: 'assets/icons/Group (26).svg',
                iconColor: const Color(0xFF653FE4),
                title: 'Document & Card Details',
                child: _buildDocumentInformation(),
              ),
              _buildSectionCard(
                index: 4,
                svgAsset: 'assets/icons/Group (27).svg',
                iconColor: const Color(0xFF653FE4),
                title: 'Bank Details',
                child: _buildBankInformation(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE5E3E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 23),
          _buildStatistics(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD4D0DB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.09),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 31,
            backgroundColor: Color(0xFFF0EDFF),
            backgroundImage: AssetImage('assets/images/defaultstudent.png'),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Anjali Menon',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF17151E),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Mathematics Teacher',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF6C46E8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 11),
                _buildContactLine(
                  svgAsset: 'assets/icons/Group (28).svg',
                  text: 'anjalimenon@gmail.com',
                ),
                const SizedBox(height: 9),
                _buildContactLine(
                  svgAsset: 'assets/icons/Clip path group (3).svg',
                  text: '987664 43210',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactLine({required String svgAsset, required String text}) {
    return Row(
      children: [
        SvgPicture.asset(
          svgAsset,
          width: 15,
          height: 15,
          fit: BoxFit.contain,
          // colorFilter: iconColor == null
          //     ? null
          //     : ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF44404A), fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildStatisticItem(
            iconColor: const Color(0xFF3F3F3F),
            svgAsset: 'assets/icons/Group 951.svg',
            iconBackground: const Color(0xFFE7F0E8),
            value: '10',
            label: 'Assigned Class',
          ),
        ),
        _buildVerticalDivider(),
        Expanded(
          child: _buildStatisticItem(
            svgAsset: 'assets/icons/Group 1312.svg',
            iconColor: const Color(0xFF3F3F3F),

            iconBackground: const Color(0xFFEAE4FA),
            value: '60',
            label: 'Student Total',
          ),
        ),
        _buildVerticalDivider(),
        Expanded(
          child: _buildStatisticItem(
            svgAsset: 'assets/icons/Vector (3).svg',
            iconColor: const Color(0xFF3F3F3F),

            iconBackground: const Color(0xFFF0EAE1),
            value: '6 A',
            label: 'Assigned Class',
          ),
        ),
        _buildVerticalDivider(),
        Expanded(
          child: _buildStatisticItem(
            svgAsset: 'assets/icons/Group (15).svg',
            iconColor: const Color(0xFF3F3F3F),

            iconBackground: const Color(0xFFE7EEF1),
            value: '12-10-2026',
            label: 'Joining On',
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.only(top: 31),
      color: const Color(0xFFE7E4E9),
    );
  }

  Widget _buildStatisticItem({
    required String svgAsset,
    required Color iconColor,
    required Color iconBackground,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 41,
          height: 41,
          decoration: BoxDecoration(
            color: iconBackground,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            svgAsset,
            width: 21,
            height: 21,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
        const SizedBox(height: 9),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF18151D),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF47424C), fontSize: 9),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required int index,
    required String svgAsset,
    Color? iconColor,
    required String title,
    required Widget child,
  }) {
    final bool isExpanded = expandedSectionIndex == index;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: isExpanded
              ? primaryColor.withOpacity(0.30)
              : const Color(0xFFE3E1E6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _toggleSection(index),
              borderRadius: BorderRadius.circular(17),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 41,
                      height: 41,
                      decoration: const BoxDecoration(
                        color: iconBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        svgAsset,
                        width: 21,
                        height: 21,
                        fit: BoxFit.contain,
                        colorFilter: iconColor == null
                            ? null
                            : ColorFilter.mode(iconColor, BlendMode.srcIn),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF4D4851),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 220),
                      turns: isExpanded ? -0.25 : 0,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: isExpanded
                            ? const Color(0xFF653FE4)
                            : const Color(0xFF8E8992),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            sizeCurve: Curves.easeInOut,
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 2, 18, 20),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInformation() {
    return _buildDetailsGrid(const [
      ProfileDetail(label: 'Date Of Birth', value: '15-09-1990'),
      ProfileDetail(label: 'Gender', value: 'Female'),
      ProfileDetail(label: 'Material Status', value: 'Married'),
      ProfileDetail(label: 'Blood Group', value: 'Ab+'),
      ProfileDetail(label: 'Qualification', value: 'M.S.C., B.E.D'),
      ProfileDetail(label: 'Nationality', value: 'Indian'),
      ProfileDetail(label: 'Current Address', value: 'Kochi Kerala India'),
      ProfileDetail(label: 'Permanent Address', value: 'Kochi,India'),
    ]);
  }

  Widget _buildContactInformation() {
    return _buildDetailsGrid(const [
      ProfileDetail(label: 'Email', value: 'Serinjohnson57@Gmail.Com'),
      ProfileDetail(label: 'Phone Number', value: '976446464484'),
      ProfileDetail(label: 'Mobile Number', value: '676446464484'),
      ProfileDetail(label: 'WhatsApp Number', value: '526489599330'),
      ProfileDetail(label: 'Emergency Contact Name', value: 'Sanju V Samson'),
      ProfileDetail(label: 'Emergency Contact', value: '6347894477262'),
    ]);
  }

  Widget _buildEmploymentInformation() {
    return _buildDetailsGrid(const [
      ProfileDetail(label: 'Joining Date', value: '12-10-2024'),
      ProfileDetail(label: 'Terminate Details', value: '-'),
      ProfileDetail(label: 'Rout', value: 'Shake Mazaui Route'),
      ProfileDetail(label: 'Ot Hourly Amount', value: '30\$ Per Hr'),
      ProfileDetail(label: 'Area', value: 'Almakthum Shakzayid'),
      ProfileDetail(label: 'Market', value: 'Hjuberaea N'),
      ProfileDetail(label: 'Narration', value: 'Dummy Content'),
    ]);
  }

  Widget _buildDocumentInformation() {
    return _buildDetailsGrid(const [
      ProfileDetail(label: 'Passport Number', value: '3647859400040404'),
      ProfileDetail(label: 'Passport Issue Date', value: '12-10-2024'),
      ProfileDetail(label: 'Passport Expiry Date', value: 'Shake Mazaui Route'),
      ProfileDetail(label: 'Visa Type', value: '30\$ Per Hr'),
      ProfileDetail(label: 'Visa Number', value: 'Almakthum Shakzayid'),
      ProfileDetail(label: 'Visa Expiry Date', value: 'Hjuberaea N'),
      ProfileDetail(label: 'Labor Card Number', value: 'Dummy Content'),
      ProfileDetail(label: 'Labor Card Issue Date', value: 'Dummy Content'),
      ProfileDetail(label: 'Labor Card Expiry Date', value: '12-10-2024'),
      ProfileDetail(label: 'Insurance Number', value: '-'),
      ProfileDetail(
        label: 'Insurance Expiry Date',
        value: 'Shake Mazaui Route',
      ),
      ProfileDetail(label: 'Mol Contact Number', value: '30\$ Per Hr'),
      ProfileDetail(label: 'Sponsor Name', value: 'Almakthum Shakzayid'),
      ProfileDetail(label: 'GOSI/SSOI Number', value: 'Hjuberaea N'),
    ]);
  }

  Widget _buildBankInformation() {
    return _buildDetailsGrid(const [
      ProfileDetail(label: 'Bank Name', value: 'HDFC Bank Limited'),
      ProfileDetail(label: 'Bank Account Number', value: '3452678909373653'),
      ProfileDetail(label: 'IBAN', value: '245678922'),
      ProfileDetail(label: 'Swift Code', value: '525'),
      ProfileDetail(label: 'Bank Branch', value: 'Perinthalmanna'),
    ]);
  }

  Widget _buildDetailsGrid(List<ProfileDetail> details) {
    final int rowCount = (details.length / 2).ceil();

    return Column(
      children: List.generate(rowCount, (rowIndex) {
        final int leftIndex = rowIndex * 2;
        final int rightIndex = leftIndex + 1;

        final ProfileDetail leftDetail = details[leftIndex];

        final ProfileDetail? rightDetail = rightIndex < details.length
            ? details[rightIndex]
            : null;

        final bool isLastRow = rowIndex == rowCount - 1;

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildDetailItem(leftDetail)),
                const SizedBox(width: 24),
                Expanded(
                  child: rightDetail != null
                      ? _buildDetailItem(rightDetail)
                      : const SizedBox(),
                ),
              ],
            ),
            if (!isLastRow) ...[
              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 0.7, color: dividerColor),
              const SizedBox(height: 16),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildDetailItem(ProfileDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF464149),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          detail.value.trim().isEmpty ? '--' : detail.value,
          style: const TextStyle(
            color: Color(0xFF111126),
            fontSize: 15,
            height: 1.3,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class ProfileDetail {
  final String label;
  final String value;

  const ProfileDetail({required this.label, required this.value});
}
