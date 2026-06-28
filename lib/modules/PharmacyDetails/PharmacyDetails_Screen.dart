import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import 'package:intellipharm/modules/PharmacyDetails/ColorClassHelper.dart';
import '../../Widgets/PharmacySummaryCard.dart';
import '../../app_theme/theme_extension.dart';
import '../../helper/ContactLauncher/ContactLauncher.dart';
import 'AddNotes/AddNotes_Screen.dart';
import 'PharmacyDetails_Controller.dart';

class PharmacyDetailsScreen extends StatelessWidget {
  final int id;
  const PharmacyDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final controller = Get.put(
      PharmacyDetailsController(pharmacyId: id),
      tag: id.toString(),
    );
    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Pharmacy Details",
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Cairo',
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }
        final pharmacy = controller.pharmacyData.value;
        if (pharmacy == null) {
          return const Center(child: Text("Failed to load pharmacy details"));
        }
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: size.width * 0.04,
                right: size.width * 0.04,
                top: size.height * 0.01,
                bottom: size.height * 0.20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(size.width * 0.05),
                    decoration: BoxDecoration(
                      color: colors.component,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Get.locale?.languageCode == 'ar'
                                        ? pharmacy.nameAr
                                        : pharmacy.nameEn,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.005),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      pharmacy.region.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: pharmacy.isOpen
                                    ? const Color(0xFFE0F2F1)
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 3,
                                    backgroundColor: pharmacy.isOpen
                                        ? const Color(0xFF00796B)
                                        : Colors.red,
                                  ),
                                  SizedBox(width: size.width * 0.008),
                                  Text(
                                    pharmacy.isOpen ? "OPEN NOW" : "CLOSED",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: pharmacy.isOpen
                                          ? const Color(0xFF00796B)
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: colors.textSecondary,
                            ),
                            SizedBox(width: size.width * 0.008),
                            Expanded(
                              child: Text(
                                controller.actualAddress.value,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colors.textSecondary,
                                  height: 1.5,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.start,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 18,
                                  color: colors.textSecondary,
                                ),
                                SizedBox(width: size.width * 0.01),
                                Text(
                                  pharmacy.pharmacistName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: colors.textPrimary,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: size.width * 0.01,
                                    right: size.width * 0.01,
                                  ),
                                  child: GestureDetector(
                                    onTap: () =>
                                        ContactLauncher().showContactOptions(
                                          context,
                                          pharmacy.pharmacistPhone,
                                        ),
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        size.width * 0.025,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.phone,
                                        color: AppColors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),*/
                  PharmacySummaryCard(
                    pharmacy: controller.pharmacyData.value,
                    controller: controller,
                    //showScheduledVisit: true,
                  ),
                  SizedBox(height: size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Visit Notes",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          color: colors.textPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A2E5A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Summarize Notes",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.tune,
                              size: 16,
                              color: Colors.grey,
                            ),
                            label: const Text(
                              "Filter",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.02),
                  controller.filteredNotes.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Text(
                              "No notes available for this pharmacy.",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.filteredNotes.length,
                          itemBuilder: (context, index) {
                            final note = controller.filteredNotes[index];
                            final cardBg = ColorClassHelper().getCardColor(
                              note.noteType,
                            );
                            final txtColor = ColorClassHelper().getTextColor(
                              note.noteType,
                            );
                            final tagBg = ColorClassHelper().getTagColor(
                              note.noteType,
                            );

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 5,
                                      backgroundColor: txtColor,
                                    ),
                                    if (index !=
                                        controller.filteredNotes.length - 1)
                                      Container(
                                        width: 2,
                                        height: size.height * 0.14,
                                        color: Colors.grey[300],
                                      ),
                                  ],
                                ),
                                 SizedBox(width: size.width * 0.02),
                                Expanded(
                                  child: Container(
                                    margin:  EdgeInsets.only(bottom: size.height * 0.009),
                                    padding:  EdgeInsets.all(size.width * 0.03),
                                    decoration: BoxDecoration(
                                      color: cardBg,
                                      borderRadius: BorderRadius.circular(16),
                                      border: cardBg == Colors.white
                                          ? Border.all(
                                              color: Colors.grey.shade200,
                                            )
                                          : null,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundColor: const Color(
                                                0xFF0F2547,
                                              ),
                                              child: Text(
                                                note.authorName.substring(0, note.authorName.length > 2 ? 2
                                                    : note.authorName.length,).toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                             SizedBox(width: size.width * 0.01),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    note.authorName,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: colors.textPrimary,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Team Member",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              note.createdAt.split(' ').first,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.015),
                                        Text(
                                          note.content,
                                          style: TextStyle(
                                            fontSize: 13,
                                            height: 1.4,
                                            color: colors.textPrimary.withValues(alpha: 0.9),
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.015),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: tagBg.withValues(alpha: 0.4),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            note.noteType.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: txtColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ],
              ),
            ),

          ],
        );
      }),
      bottomNavigationBar: const AddNotesScreen(),
    );
  }


}

/*
import 'package:flutter/material.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';

class VisitNote {
  final String authorName;
  final String role;
  final String initials;
  final String date;
  final String content;
  final String type; // TIP, GENERAL, WARNING
  final Color cardColor;
  final Color tagColor;
  final Color textColor;

  const VisitNote({
    required this.authorName,
    required this.role,
    required this.initials,
    required this.date,
    required this.content,
    required this.type,
    required this.cardColor,
    required this.tagColor,
    required this.textColor,
  });
}

class PharmacyDetailsScreen extends StatelessWidget {
  final int id;
  const PharmacyDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    print("ID:$id");
    final List<VisitNote> mockNotes = [
      const VisitNote(
        authorName: "Ahmad J.",
        role: "Medical Representative",
        initials: "AJ",
        date: "6 Apr, 10:15 AM",
        content:
            "Pharmacist prefers oral antibiotics category. Highlight the new enteric-coated range next visit.",
        type: "TIP",
        cardColor: Color(0xFFE0F7F4),
        tagColor: Color(0xFF64FFDA),
        textColor: Color(0xFF00BFA5),
      ),
      const VisitNote(
        authorName: "Sarah M.",
        role: "Area Manager",
        initials: "SM",
        date: "5 Apr, 02:45 PM",
        content:
            "Best visit time: before 11 AM. The store gets crowded with patients later in the afternoon.",
        type: "GENERAL",
        cardColor: Colors.white,
        tagColor: Color(0xFFEEEEEE),
        textColor: Colors.grey,
      ),
      const VisitNote(
        authorName: "Ahmad J.",
        role: "Medical Representative",
        initials: "AJ",
        date: "1 Apr, 09:30 AM",
        content:
            "Ask about last month's unsold stock. Client mentioned storage space constraints.",
        type: "WARNING",
        cardColor: Color(0xFFFDF2E9),
        tagColor: Color(0xFFFEDBB7),
        textColor: Color(0xFFE67E22),
      ),
    ];

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        foregroundColor: colors.textPrimary,
        centerTitle: false,
        title: Text(
          "Pharmacy Details",
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Cairo',
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: size.width * 0.04,
              right: size.width * 0.04,
              top: size.height * 0.01,
              bottom: size.height *0.18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(size.width * 0.05),
                  decoration: BoxDecoration(
                    color: colors.component,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Al-Shifa Pharmacy",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                    color: colors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.005),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "NORTH REGION",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2F1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircleAvatar(
                                  radius: 3,
                                  backgroundColor: Color(0xFF00796B),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "HIGH PRIORITY",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: const Color(0xFF00796B),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: colors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "72nd Architectural Square, Medical District, Sector 4B, Central Heights",
                              style: TextStyle(
                                fontSize: 13,
                                color: colors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 18,
                                color: colors.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "+1 (555) 0984-212",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: colors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xFF4FF3CE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.phone,
                              color: Color(0xFF004D40),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                /// 2️⃣ ترويسة قسم الملاحظات والفلترة (Visit Notes Header Row)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Visit Notes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        color: colors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A2E5A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Summarize Notes",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.tune,
                            size: 16,
                            color: Colors.grey,
                          ),
                          label: const Text(
                            "Filter",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),

                /// 3️⃣ خط الزمن والملاحظات (Timeline & Notes List)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: mockNotes.length,
                  itemBuilder: (context, index) {
                    final note = mockNotes[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // خط الـ Timeline والنقط الجانبية
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 5,
                              backgroundColor: note.textColor,
                            ),
                            if (index != mockNotes.length - 1)
                              Container(
                                width: 2,
                                height: size.height * 0.16,
                                color: Colors.grey[300],
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),

                        // كارت الملاحظة المطابق للتصميم تماماً
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: note.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: note.cardColor == Colors.white
                                  ? Border.all(color: Colors.grey.shade200)
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: const Color(0xFF0F2547),
                                      child: Text(
                                        note.initials,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            note.authorName,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: colors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            note.role,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      note.date,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * 0.015),
                                Text(
                                  note.content,
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.4,
                                    color: colors.textPrimary?.withOpacity(0.9),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.015),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: note.tagColor.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    note.type,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: note.textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          /// 4️⃣ البار السفلي لإضافة ملاحظة والفلترة (Bottom Sticky Input Panel)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: colors.component,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // الـ Filter Chips السفلية الصغيرة
                    Row(
                      children: [
                        _buildBottomChip(
                          "GENERAL",
                          Colors.grey[200]!,
                          Colors.grey[700]!,
                          true,
                        ),
                        const SizedBox(width: 8),
                        _buildBottomChip(
                          "TIP",
                          const Color(0xFFE0F7F4),
                          const Color(0xFF00BFA5),
                          false,
                        ),
                        const SizedBox(width: 8),
                        _buildBottomChip(
                          "WARNING",
                          const Color(0xFFFDF2E9),
                          const Color(0xFFE67E22),
                          false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // حقل الإدخال وزر الإرسال الأنيق
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: "Add a note...",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0F2547),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت مساعدة لبناء الفلاتر الشيبس السفلية
  Widget _buildBottomChip(
    String label,
    Color bgColor,
    Color textColor,
    bool isSelected,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: textColor.withOpacity(0.5), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 3, backgroundColor: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
*/
