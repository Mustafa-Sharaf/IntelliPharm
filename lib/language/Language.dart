import 'package:get/get.dart';

class MyLanguage implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    "en": {
      //LogIn Screen $ Splash Screen
      "INTELLI_PHARMA": "INTELLI\nPHARMA",
      "SignIn": "Sign In",
      "WelcomeBack": "Welcome Back!",
      "Password": "Password",
      "EmailAddress": "Email Address",
      "Log_In": "Log In",
      "Don’tHaveLoginCredentialsContactAdmin":
          "Don’t have login credentials? Contact admin.",
      "Note": "Note",
      "YouCannotChangeYourPassword":
          "You cannot change your password.\n Please contact your admin to reset it.",
      "OK": "OK",
      "ForgotPassword": "Forgot password",
      //Home Screen
      "MyDeliveries": "My Deliveries",
      "ActiveRouteProgress": "Active Route Progress",
      "ConfirmDelivery": "Confirm Delivery",
      "MyOrders": "My Orders",
      "DEBTSScreen": "DEBTS Screen",
      "PharmacistsScreen": "Pharmacists Screen",
      "Search_Pharmacists...": "Search Pharmacists...",
      //HomeContent Screen & Home Content Distributor Screen
      "Visits": "Visits",
      "Deals": "Deals",
      "Order": "Order",
      "Today's_Visits": "Today's Visits",
      "See_All": "See All",
      "NoVisitsPlannedYet": "No visits planned yet.",
      "ThePharmaciesWillAppearHereOnceYouHaveSelectedTheAreaYouWillBeVisiting":
          "The pharmacies will appear here once you have selected the area you will be visiting.",
      "CreatePlan": "Create Plan",
      "ActiveOffers": "Active Offers",
      "StartDeliveryRoute": "Start Delivery Route",
      "ASSIGNED": "ASSIGNED",
      "COMPLETED": "COMPLETED",
      "Today'sDeliveries": "Today's Deliveries",
      "NoDeliveriesToday": "No Deliveries Today",
      "ViewMap": "View Map",
      //Active Optimized Route Tracking Screen
      "NEXT_DESTINATION": "NEXT DESTINATION",
      "AllDestinationsHaveBeenVisitedOrThereIsNoCurrentRoute":
          "All destinations have been visited or there is no current route",
      "RePlan": "RePlan",
      "ROUTE_SCHEDULE": "ROUTE SCHEDULE",
      "VISITED_AT": "Visited at @time",
      "ETA_TIME": "ETA: @time",
      "CURRENT_ROUTE": "CURRENT ROUTE",
      "LoadingRoute": "Loading route...",
      "STOPS_COUNT": "@count stops",
      "DURATION_HM": "@hours h @minutes m",
      "DURATION_M": "@minutes m",
      "DISTANCE_M": "@meters m",
      "DISTANCE_KM": "@distance km",
      "AM": "AM",
      "PM": "PM",
      "ZERO_KM": "0 km",
      // Add Notes
      "GENERAL": "GENERAL",
      "TIP": "TIP",
      "WARNING": "WARNING",
      "AddANote": "Add a note...",
      "Medicines": "Medicines",
      "Imported": "Imported",
      "Local": "Local",
      "PRICE_SP": "@price S.P",
      "GIFT_PROMO": "Buy @required_qty Get @gift_qty Free",
      //Add Pharmacy Screen
      "AddPharmacy": "Add Pharmacy",
      "REGION": "REGION",
      "PHARMACY_NAME": "PHARMACY NAME",
      "WORKING_HOURS": "WORKING HOURS",
      "LOCATION": "LOCATION",
      "Opening_Time": "Opening Time",
      "Closing_Time": "Closing Time",
      "HOLIDAYS": "HOLIDAYS",
      "CONTACT_INF": "CONTACT INF",
      "SAVE_PHARMACY": "SAVE PHARMACY",
      "HOLIDAYS_SELECTED": "@selected/@max selected",
      "Latitude": "Latitude",
      "Longitude": "Longitude",
      "PharmacistName(Optional)": "Pharmacist Name (Optional)",
      "EnterPharmacistName": "Enter Pharmacist Name",
      "PhoneNumber": "Phone Number",
      "This_field_is_required": "This field is required",
      "Please_enter_numbers_only": "Please enter numbers only",
      "Phone_number_must_be_exactly_10_digits":
          "Phone number must be exactly 10 digits",
      "Enter_phone_number": "Enter phone number",
      "Alternative_Phone_(Optional)": "Alternative Phone (Optional)",
      "Name(English)": "Name (English)",
      "Name(Arabic)": "Name (Arabic)",
      "Enter_the_name_of_the_pharmacy_in_Arabic":
          "Enter the name of the pharmacy in Arabic",
      "Arabic_characters_only": "Arabic characters only",
      //Chat Screen
      "No_local_history_found": "No local history found",
      "New_Chat": "New Chat",
      "Write_your_question_below_to_get_started":
          "Write your question below to get started",
      "How_can_I_help_you_today": "How can I help you today ?",
      "IntelliPharma_AI": "IntelliPharma AI",
      "CONVERSATION_ID": "Conversation #@id",
      "Type_your_question_and_then_press_Enter_or_press_Submit":
          "Type your question and then press Enter or press Submit.",
      "Write_your_question_here": "Write your question here...",
      //My Deliveries Screen
      "Pending": "Pending",
      "InTransit": "InTransit",
      "Delivered": "Delivered",
      "All": "All",
      "No_orders_found_for_this_tab": "No orders found for this tab",
      "DELIVERY_SUMMARY":
          "@pending PENDING · @transit IN TRANSIT · @delivered DELIVERED TODAY",
      //My Orders Screen
      "Processing": "Processing",
      "Completed": "Completed",
      "Cancelled": "Cancelled",
      //New Order Screen
      "NewOrder": "NewOrder",
      "SELECT_PHARMACY": "SELECT PHARMACY",
      "ORDER_ITEMS": "ORDER ITEMS",
      "NOTES": "NOTES",
      "Add_optional_order_notes...": "Add optional order notes...",
      "TotalPrice": "Total Price",
      "SubmitOrder": "Submit Order",
      "ITEMS_COUNT": "@count Items",
      //Pharmacists Screen
      "No_pharmacies_found": "No pharmacies found",
      "PHARMACIES_FOUND": "@count pharmacies found",
      "CloseNow": "Close Now",
      "OpenNow": "Open Now",
      "AllRegions": "All Regions",
      "Directions": "Directions",
      "ViewNotes": "View Notes",
      //Pharmacy Details Screen
      "PharmacyDetails": "Pharmacy Details",
      "Failed_to_load_pharmacy_details": "Failed to load pharmacy details",
      "VisitNotes": "VisitNotes",
      "ALL": "ALL",
      "No_notes_available_for_this_filter.":
          "No notes available for this filter.",
      //PlanYourRoute
      "PlanYourRoute": "PlanYourRoute",
      "TRAVEL_MODE": "TRAVEL MODE",
      "Select_Pharmacies_to_Visit": "Select Pharmacies to Visit",
      "Search_pharmacy_name_...": "Search pharmacy name ...",
      "Nothing_pharmacies_yet.": "Nothing pharmacies yet.",
      "The_pharmacies_will_appear_here_once_you_have_selected_the_area_you_will_be_visiting.":
          "The pharmacies will appear here once you have selected the area you will be visiting.",
      "GenerateOptimalRoute": "Generate Optimal Route",
      "SelectRegion": "Select Region",
      "Fastest": "Fastest",
      "Cheapest": "Cheapest",
      "VIP First": "VIP First",
      "Priority": "Priority",
      "Balanced": "Balanced",
      "All Factors": "All Factors",
      "Fastest available route for now": "Fastest available route for now",
      "Route that reduces fuel consumption":
          "Route that reduces fuel consumption",
      "Serve the most important pharmacies first":
          "Serve the most important pharmacies first",
      "Serve the highest priority deliveries first":
          "Serve the highest priority deliveries first",
      "Middle ground between options": "Middle ground between options",
      "Combination of the options above": "Combination of the options above",
      "Please_select_route_profile": "Please select route profile",
      "Select_Optimization_Profile": "Select Optimization Profile",
      "PROFILE": "ROUTE STRATEGY",
      "pharmacies_selected": "@count selected",
      //RePlan Route Screen
      "Re-planRoute": "Re-planRoute",
      "WHY_ARE_YOU_RE-PLANNING_?": "WHY ARE YOU RE-PLANNING ?",
      "REMOVE_UNVISITED_STOPS": "REMOVE UNVISITED STOPS",
      "Re-plan_Now": "Re-plan Now",
      "Other": "Other",
      //Search
      "Search_medicines...": "Search medicines...",
      //Order Details Screen
      "No_data": "No data",
      "ShowOrder": "Show Order",
      "Total": "Total",
      "Percentage": "Percentage",
      "FinalPrice": "Final Price",
      "OrderItems": "Order Items",
      "Notes": "Notes",
      "No_notes_available": "No notes available",
      //Visit Details Screen
      "VisitDetails": "Visit Details",
      "RecentNotes": "Recent Notes",
      "ViewAllNotes": "View All Notes",
      "No_notes_available_for_this_pharmacy_yet.":
          "No notes available for this pharmacy yet.",
      "Visit_Actions": "Visit Actions",
      "ClosedDeal": "Closed Deal",
      "NoDeal": "No Deal",
      "Map": "Map",
      "Call": "Call",
      "CreateOrder": "Create Order",
      //Nav Item
      "HOME": "HOME",
      "ORDERS": "ORDERS",
      "AskGemini": "AskGemini",
      "Debts": "Debts",
      "Pharmacies": "Pharmacies",
      "Deliveries": "Deliveries",
      "Route": "Route",
      "DELIVERIES": "DELIVERIES",
      //Pharmacy Selector
      "Search_pharmacy...": "Search pharmacy...",
      "Region": "Region",
      "SelectPharmacy": "Select Pharmacy",
      "Search_for_an_area...": "Search for an area...",
      "+AddMedicine": "+ Add Medicine",
      "User": "User",
      "HI_USER": "Hi, @name",
      "Success": "Success",
      "Error": "Error",
      "DELIVERY_DATE": "DELIVERY DATE",
      //Delivery Card
      "SCHEDULE": "SCHEDULE",
      "INVENTORY": "INVENTORY",
      "DeliveredSuccessfully": "Delivered Successfully",
      "InTransit...": "In Transit...",
      "StartDelivery": "Start Delivery",
      "LOW": "LOW",
      "NORMAL": "NORMAL",
      "URGENT": "URGENT",
      "ITEMS_PRICE_SUMMARY": "@count items · @price S.P",
      "EST_TIME": "EST: @time",
      "ASSIGNED_TIME": "Assigned: @time",
      "LanguageEditing": "Language Editing",
      //Medicine Card
      "Add_to_cart": "Add to cart",
      "Alternatives": "Alternatives",
      "QTY_STOCK": "Qty: @stock",
      "UNIT_PRICE_SP": "Unit Price: @price S.P",
      "Remove": "Remove",
      //Drawer Home
      "Privacy_Policy": "Privacy Policy",
      "Logout": "Logout",
      "Share_Application": "Share Application",
      "Theme_Toggle": "Theme Toggle",
      "Support": "Support",
      "Application_language": "Application language",
      "My_Targets": "My Targets",
      "My_Profile": "My Profile",
      "MySitting": "My Sitting",
      "IntelliPharma": "IntelliPharma",
      "Active_Offers": "Active Offers",
      "Plan_Today's_Route": "Plan Today's\nRoute",
      "TeamMember": "Team Member",
      "ORDER_ID": "ORDER #@id",
      "PENDING": "PENDING",
      "VISITED": "VISITED",
      "Closed": "Closed",
      "Open": "Open",
      "PHARMACIST_NAME": "Pharmacist: @name",

      //Order Priority Extension
      "IN_TRANSIT": "IN TRANSIT",
      "DELIVERED": "DELIVERED",
      "ORDER_NUMBER": "Order #@number",
      //Pharmacy Route Dialog
      "ROUTE_TO_PHARMACY": "Route to @name",
      //Pharmacy Summary Card
      "SCHEDULED_VISIT": "SCHEDULED VISIT",
      "CLOSED": "CLOSED",
      "OPEN_NOW": "OPEN NOW",
      "HOLIDAY_LABEL": "Holiday: @text",
      //PlanRouteCard
      "Today's_planned_visits": "Today's planned visits",
      "PlanToday'sRoute": "Plan Today's Route",
      //Route Step Item
      "Visit_Details": "Visit Details",

      "GIFT_QUANTITY": "Gift Qty: @gift",
      "UNITS_COUNT": "@count units",
      "Walking": "Walking",
      "Driving": "Driving",
      //Active Delivery RouteScreen
      "NoCurrentDataPath": "No current data path",
      "DELIVERY_TIMELINE": "DELIVERY TIMELINE",
      "The_map_is_being_created...": "The map is being created...",
      //Confirm Delivery Screen
      "ORDER_REFERENCE": "ORDER REFERENCE",
      "ORDER_REFERENCE_VALUE": "#ORD-@orderId",
      "REGION_NAME": "Region: @region",

      "PROOF_OF_DELIVERY": "PROOF OF DELIVERY",
      "Take_Photo": "Take Photo",
      "Tap_to_capture_parcel": "Tap to capture parcel",
      "RECEIVER_NAME": "RECEIVER NAME",
      "PAYMENT_AMOUNT_(OPTIONAL)": "PAYMENT AMOUNT (OPTIONAL)",
      "CHECK_NOTES_(OPTIONAL)": "CHECK NOTES (OPTIONAL)",
      "Add_any_delivery_satisfaction_notes":
          "Add any delivery satisfaction notes",
      "Recipient's_name": "Recipient's name",
      "Processing...": "Processing...",
      "ETA_ORDER": "ETA @eta • Order #@orderId",

      // privacy policy  Screen
      'privacy_policy_title': 'Privacy Policy',
      'privacy_policy_content': '''
      At IntelliPharma, we attach great importance to the privacy and security of your data. This policy outlines how we collect, use, and protect your information when using our application.

     1. Information We Collect:
     • Account Information: Such as name, phone number, and job role (Medical Representative / Distributor).
     • Location Data (GPS): Geographic location is used to pinpoint registered pharmacies and facilitate planning daily visits and delivery routes.
     • Images & Attachments: When uploading photos of pharmacies, documents, or order details.

     2. How We Use Information:
     • Organizing and updating daily visit plans and delivery routes.
     • Managing orders and financial records related to pharmacies.
     • Enhancing user experience and overall application performance.

      3. Data Sharing:
      • We commit not to sell or share your data with any external commercial third parties.
      • Data is strictly used within the scope of warehouse operations and management.

      4. Data Security:
      • We implement appropriate technical security measures to protect your data from unauthorized access.

      5. Contact & Support:
      • If you have any questions regarding this Privacy Policy, you can reach out through the Technical Support section in the application.
      ''',

      "IntelliPharma_Privacy_&_Security": "IntelliPharma Privacy & Security",
      "Search...": "Search...",
      "All_Categories": "All Categories",
      "NoNotifications": "NoNotifications",
      "Notifications": "Notifications",
      "DeliveryConfirmation": "Delivery Confirmation",
      "Start_of_visit": "Start of visit",
      "Change_status": "Change status",
      "Change_visit_status": "Change visit status",
      "Choose_the_reason_for_non-completion...":
          "Choose the reason for non-completion...",
      "Enter_additional_notes_(optional)...":
          "Enter additional notes (optional)...",
      "Please_select_the_reason_first.": "Please select the reason first.",
      'pharmacy_closure': 'Pharmacy Closed',
      'traffic_jam': 'Traffic Jam',
      'official_holiday': 'Official Holiday',
      'weather_conditions': 'Weather Conditions',
      'pharmacist_delay': 'Pharmacist Delay',
      'status_blocked': 'Blocked',
      'status_failed': 'Failed',
      'status_skipped': 'Skipped',
      "WHY_ARE_YOU_RE-PLANNING": "WHY ARE YOU RE-PLANNING?",
      "Enter_the_reason_for_re-planning...":
          "Enter the reason for re-planning...",
      "Submit": "Submit",
      "Cancel": "Cancel",
      'road_closure': 'Road Closure',
      'accident_ahead': 'Accident Ahead',
      'pharmacy_closed': 'Pharmacy Closed',
      'schedule_change': 'Schedule Change',
      'other': 'Other',
      //Edit Order
      "EditOrder": "Edit Order",
      "No_items_in_order": "No items in order",
      "AddNewMedicine": "Add New Medicine",
      "SaveChanges": "Save Changes",
      "AddMedicineToOrder": "Add Medicine To Order",
      "OnTheWay": "On The Way",

      //Debts Screen
      "TOTAL_OUTSTANDING_BALANCE": "TOTAL OUTSTANDING BALANCE",
      "Total_Billed": "Total Billed",
      "Total_Paid": "Total Paid",
      "amount_sp": "@amount S.p",
      "percent_collected": "@percent% Collected",
      "percent_remaining": "@percent% Remaining",
      "OVERDUE": "OVERDUE",
      "PARTIAL": "PARTIAL",
      "PAID": "PAID",
      "filter_all": "All",
      "filter_fully_paid": "Fully Paid",
      "filter_partially_paid": "Partially Paid",
      "filter_pending": "Pending",
      "filter_overdue": "Overdue",
      "pharmacies_outstanding_summary":
          "@count Pharmacies - @amount S.p Outstanding",
      "Remaining": "Remaining",
      "Paid": "Paid",
      "percent_paid": "@percent% paid",
      "last_payment_date": "Last payment: @date",
      "No_debts_or_records_found": "No debts or records found",
      "Record_Payment": "Record Payment",
      "Invoices/Orders": "Invoices/Orders",
      "Payments": "Payments",
      "Last_Payment": "Last_Payment",
      "Remaining_Balance": "Remaining_Balance",
      "payment_amount": "+@amount S.p",
      "ref_label": "Ref:",
      "collected_by_label": "Collected by:",
      "balance_after_label": "Balance after:",
      "balance_amount_sp": "@amount S.p",
      "no_payments_found": "No payments recorded yet",
      "paid_uppercase": "PAID",
      "remaining_uppercase": "REMAINING",
      "no_invoices_found": "No invoices or orders found",
      //payment Screen
      "record_payment_title": "Record Payment",
      "outstanding_balance_label": "OUTSTANDING BALANCE",
      "payment_amount_label": "PAYMENT AMOUNT",
      "type_to_edit_hint": "Type to edit the payment amount",
      "current_balance_label": "Current Balance",
      "payment_label": "Payment",
      "new_balance_label": "NEW BALANCE",
      "payment_date_label": "Payment Date",
      "notes_optional_label": "Notes (Optional)",
      "add_payment_context_hint": "Add payment context...",
      "confirm_payment_btn": "Confirm Payment",
      "invalid_amount_err": "Please enter a valid amount",
      "payment_success_msg": "Payment created successfully",
      "Are_you_sure_you_want_to_logout?":"Are you sure you want to logout?",
      "No":"No",
      "Yes":"Yes",
      //ProfileScreen
      'Representative Profile': 'Representative Profile',
      'Senior Sales Representative': 'Senior Sales Representative',
      'NORTH REGION': 'NORTH REGION',
      'CONTACT': 'CONTACT',
      'Active Clients': 'Active Clients',
      'Orders this month': 'Orders this month',
      'Average Deal Size': 'Average Deal Size',
      'Performance Targets': 'Performance Targets',
      'MONTHLY PROGRESS': 'MONTHLY PROGRESS',
      'QUARTERLY PROGRESS': 'QUARTERLY PROGRESS',
      'of': 'of',
      'achieved': 'achieved',
      'failed_to_load_profile': 'Failed to load profile',
      'Monthly Sales Target': 'Monthly Sales Target',
      'Quarterly Sales Target': 'Quarterly Sales Target',
      //Medicine Details Screen
      'Medicine_Details': 'Medicine Details',
      'PRICE_PER_UNIT': 'PRICE PER UNIT',
      'STOCK_AVAILABLE': 'STOCK AVAILABLE',
      'MANUFACTURER': 'MANUFACTURER',
      'BARCODE': 'BARCODE',
      'Failed_to_load_details': 'Failed to load details',
      "units":"units",
      "SP":"S.P",
      'No_Offers_Available': 'No offers or gifts available for this medicine',
      'No_Alternatives_Available': 'No alternatives available for this medicine currently',

      'OFF': 'OFF',
      'GIFT': 'GIFT',
      'DiscountOffer': 'Discount Offer',
      'FreeGift': 'Free Gift',
      'MinOrder': 'Min. Order',
      "Items": "@items items",
      "Cancel_Order":"Cancel Order",
      "Are_you_sure_cancel_order":"Are you sure cancel order",
      "DELETE_CART_QUESTION":"Do you want to delete it?",
      "CONFIRM_EXIT":"CONFIRM EXIT",

      //AppSnackBar
      "Visit_started_successfully":"Visit started successfully.",
      "Failed_to_start_visit":"Failed to start visit.",
      "Failed_to_start_visit_please_try_again":"Failed to start visit, please try again.",
      "Logging_out...":"Logging out...",
      //ContactLauncher
      "Choose_a_method_of_communication":"Choose a method of communication",
      "Start_a_live_chat":"Start a live chat",
      "WhatsApp":"WhatsApp",
      "Telephone_call":"Telephone call",
      "Making_a_voice_call":"Making a voice call",
      "Send_SMS":"Send SMS",
      "Text_message":"Text message",
      "No_Active_Plan":"No Active Plan",
      "":"",
      "":"",
      "":"",
      "":"",
      "":"",
      "":"",
      "":"",
      "":"",
      "":"",
      "":"",








    },

    "ar": {
      // LogIn Screen & Splash Screen
      "INTELLI_PHARMA": "إنتيلي\nفارما",
      "SignIn": "تسجيل الدخول",
      "WelcomeBack": "مرحباً بك مجدداً!",
      "Password": "كلمة المرور",
      "EmailAddress": "البريد الإلكتروني",
      "Log_In": "دخول",
      "Don’tHaveLoginCredentialsContactAdmin":
          "لا تملك بيانات دخول؟ تواصل مع المسؤول.",
      "Note": "ملاحظة",
      "YouCannotChangeYourPassword":
          "لا يمكنك تغيير كلمة المرور الخاصة بك.\nيرجى التواصل مع المسؤول لإعادة تعيينها.",
      "OK": "موافق",
      "ForgotPassword": "نسيت كلمة المرور",

      // Home Screen
      "MyDeliveries": "شحناتي",
      "ActiveRouteProgress": "مسار التوصيل النشط",
      "ConfirmDelivery": "تأكيد التوصيل",
      "MyOrders": "طلباتي",
      "DEBTSScreen": "شاشة الديون",
      "PharmacistsScreen": "شاشة الصيادلة",

      // HomeContent Screen & Home Content Distributor Screen
      "Visits": "الزيارات",
      "Deals": "الصفقات",
      "Order": "الطلب",
      "Today's_Visits": "زيارات اليوم",
      "See_All": "عرض الكل",
      "NoVisitsPlannedYet": "لم يتم التخطيط لأي زيارات بعد.",
      "ThePharmaciesWillAppearHereOnceYouHaveSelectedTheAreaYouWillBeVisiting":
          "ستظهر الصيدليات هنا بمجرد تحديد المنطقة التي ستقوم بزيارتها.",
      "CreatePlan": "إنشاء خطة",
      "ActiveOffers": "العروض النشطة",
      "StartDeliveryRoute": "بدء مسار التوصيل",
      "ASSIGNED": "مُعيَّن",
      "COMPLETED": "مكتمل",
      "Today'sDeliveries": "شحنات اليوم",
      "NoDeliveriesToday": "لا توجد شحنات اليوم",
      "ViewMap": "عرض الخريطة",

      // Active Optimized Route Tracking Screen
      "NEXT_DESTINATION": "الوجهة التالية",
      "AllDestinationsHaveBeenVisitedOrThereIsNoCurrentRoute":
          "تمت زيارة جميع الوجهات أو لا يوجد مسار حالي",
      "RePlan": "إعادة تخطيط",
      "ROUTE_SCHEDULE": "جدول المسار",
      "VISITED_AT": "تمت الزيارة في @time",
      "ETA_TIME": "الوقت المتوقع للوصول: @time",
      "CURRENT_ROUTE": "المسار الحالي",
      "LoadingRoute": "جاري تحميل المسار...",
      "STOPS_COUNT": "@count محطات",
      "DURATION_HM": "@hours ساعة و @minutes دقيقة",
      "DURATION_M": "@minutes دقيقة",
      "DISTANCE_M": "@meters متر",
      "DISTANCE_KM": "@distance كم",
      "AM": "ص",
      "PM": "م",
      "ZERO_KM": "0 كم",

      // Add Notes
      "GENERAL": "عام",
      "TIP": "نصيحة",
      "WARNING": "تحذير",
      "AddANote": "إضافة ملاحظة...",
      "Medicines": "الأدوية",
      "Imported": "مستورد",
      "Local": "محلي",
      "PRICE_SP": "@price ل.س",
      "GIFT_PROMO": "اشترِ @required_qty واحصل على @gift_qty مجاناً",

      // Add Pharmacy Screen
      "AddPharmacy": "إضافة صيدلية",
      "REGION": "المنطقة",
      "PHARMACY_NAME": "اسم الصيدلية",
      "WORKING_HOURS": "أوقات العمل",
      "LOCATION": "الموقع",
      "Opening_Time": "وقت الافتتاح",
      "Closing_Time": "وقت الإغلاق",
      "HOLIDAYS": "العطل الرسمية",
      "CONTACT_INF": "معلومات الاتصال",
      "SAVE_PHARMACY": "حفظ الصيدلية",
      "HOLIDAYS_SELECTED": "تم تحديد @selected من أصل @max",
      "Latitude": "خط العرض",
      "Longitude": "خط الطول",
      "PharmacistName(Optional)": "اسم الصيدلي (اختياري)",
      "EnterPharmacistName": "أدخل اسم الصيدلي",
      "PhoneNumber": "رقم الهاتف",
      "This_field_is_required": "هذا الحقل مطلوب",
      "Please_enter_numbers_only": "الرجاء إدخال أرقام فقط",
      "Phone_number_must_be_exactly_10_digits":
          "يجب أن يتكون رقم الهاتف من 10 أرقام تماماً",
      "Enter_phone_number": "أدخل رقم الهاتف",
      "Alternative_Phone_(Optional)": "هاتف بديل (اختياري)",
      "Name(English)": "الاسم (بالإنكليزية)",
      "Name(Arabic)": "الاسم (بالعربية)",
      "Enter_the_name_of_the_pharmacy_in_Arabic":
          "أدخل اسم الصيدلية باللغة العربية",
      "Arabic_characters_only": "أحرف عربية فقط",

      // Chat Screen
      "No_local_history_found": "لم يتم العثور على سجل محلي",
      "New_Chat": "محادثة جديدة",
      "Write_your_question_below_to_get_started": "اكتب سؤالك في الأسفل للبدء",
      "How_can_I_help_you_today": "كيف يمكنني مساعدتك اليوم؟",
      "IntelliPharma_AI": "مساعد إنتيلي فارما الذكي",
      "CONVERSATION_ID": "محادثة رقم @id",
      "Type_your_question_and_then_press_Enter_or_press_Submit":
          "اكتب سؤالك ثم اضغط Enter أو إرسال.",
      "Write_your_question_here": "اكتب سؤالك هنا...",

      // My Deliveries Screen
      "Pending": "قيد الانتظار",
      "InTransit": "جاري التوصيل",
      "Delivered": "تم التسليم",
      "All": "الكل",
      "No_orders_found_for_this_tab": "لم يتم العثور على طلبات في هذا التبويب",
      "DELIVERY_SUMMARY":
          "@pending قيد الانتظار · @transit جاري التوصيل · @delivered تم تسليمها اليوم",

      // My Orders Screen
      "Processing": "قيد المعالجة",
      "Completed": "مكتمل",
      "Cancelled": "ملغي",

      // New Order Screen
      "NewOrder": "طلب جديد",
      "SELECT_PHARMACY": "اختر الصيدلية",
      "ORDER_ITEMS": "عناصر الطلب",
      "NOTES": "ملاحظات",
      "Add_optional_order_notes...": "إضافة ملاحظات اختيارية على الطلب...",
      "TotalPrice": "السعر الإجمالي",
      "SubmitOrder": "إرسال الطلب",
      "ITEMS_COUNT": "@count عناصر",

      // Pharmacists Screen
      "No_pharmacies_found": "لم يتم العثور على صيدليات",
      "PHARMACIES_FOUND": "تم العثور على @count صيدلية",
      "Search_Pharmacists...": "ابحث عن الصيادلة...",
      "CloseNow": "مغلق الآن",
      "OpenNow": "مفتوح الآن",
      "AllRegions": "كل المناطق",
      "Directions": "الموقع",
      "ViewNotes": "عرض الملاحظات",

      // Pharmacy Details Screen
      "PharmacyDetails": "تفاصيل الصيدلية",
      "Failed_to_load_pharmacy_details": "فشل تحميل تفاصيل الصيدلية",
      "VisitNotes": "ملاحظات الزيارة",
      "ALL": "الكل",
      "No_notes_available_for_this_filter.":
          "لا توجد ملاحظات متاحة لهذا الفلتر.",

      // PlanYourRoute
      "PlanYourRoute": "خطط لمسارك",
      "TRAVEL_MODE": "طريقة التنقل",
      "Select_Pharmacies_to_Visit": "اختر الصيدليات لزيارتها",
      "Search_pharmacy_name_...": "ابحث عن اسم الصيدلية...",
      "Nothing_pharmacies_yet.": "لا توجد صيدليات بعد.",
      "The_pharmacies_will_appear_here_once_you_have_selected_the_area_you_will_be_visiting.":
          "ستظهر الصيدليات هنا بمجرد تحديد المنطقة التي ستقوم بزيارتها.",
      "GenerateOptimalRoute": "توليد المسار الأمثل",
      "SelectRegion": "اختر المنطقة",
      "Fastest": "الأسرع",
      "Cheapest": "الأوفر استهلاكاً",
      "VIP First": "الأولوية للـ VIP",
      "Priority": "الأولوية للشحنات",
      "Balanced": "متوازن",
      "All Factors": "جميع العوامل",
      "Fastest available route for now": "أسرع مسار متاح حالياً للوصول",
      "Route that reduces fuel consumption":
          "مسار يقلل استهلاك الوقود والتكلفة",
      "Serve the most important pharmacies first":
          "خدمة الصيدليات الأكثر أهمية أولاً",
      "Serve the highest priority deliveries first":
          "إنجاز التوصيلات ذات الأولوية العالية أولاً",
      "Middle ground between options": "حل متوازن يجمع بين السرعة والتكلفة",
      "Combination of the options above": "دمج متكافئ لجميع المعايير السابقة",
      "Please_select_route_profile": "يرجى تحديد ملف تعريف المسار",
      "Select_Optimization_Profile": "حدد ملف تعريف التحسين",
      "PROFILE": "استراتيجية المسار",
      "pharmacies_selected": "@count محددة",

      // RePlan Route Screen
      "Re-planRoute": "إعادة تخطيط المسار",
      "WHY_ARE_YOU_RE-PLANNING_?": "لماذا تقوم بإعادة التخطيط؟",
      "REMOVE_UNVISITED_STOPS": "إزالة المحطات غير المزارة",
      "Re-plan_Now": "إعادة التخطيط الآن",
      "Other": "أخرى",

      // Search
      "Search_medicines...": "البحث عن الأدوية...",

      // Order Details Screen
      "No_data": "لا توجد بيانات",
      "ShowOrder": "عرض الطلب",
      "Total": "المجموع",
      "Percentage": "النسبة المئوية",
      "FinalPrice": "السعر النهائي",
      "OrderItems": "عناصر الطلب",
      "Notes": "الملاحظات",
      "No_notes_available": "لا توجد ملاحظات متاحة",

      // Visit Details Screen
      "VisitDetails": "تفاصيل الزيارة",
      "RecentNotes": "الملاحظات الأخيرة",
      "ViewAllNotes": "عرض كافة الملاحظات",
      "No_notes_available_for_this_pharmacy_yet.":
          "لا توجد ملاحظات لهذه الصيدلية بعد.",
      "Visit_Actions": "إجراءات الزيارة",
      "ClosedDeal": "صفقة مغلقة",
      "NoDeal": "لا توجد صفقة",
      "Map": "الخريطة",
      "Call": "اتصال",
      "CreateOrder": "إنشاء طلب",

      // Nav Item
      "HOME": "الرئيسية",
      "ORDERS": "الطلبات",
      "AskGemini": "المساعد الذكي",
      "Debts": "الديون",
      "Pharmacies": "الصيدليات",
      "Deliveries": "الشحنات",
      "Route": "المسار",
      "DELIVERIES": "الشحنات",

      // Pharmacy Selector
      "Search_pharmacy...": "ابحث عن صيدلية...",
      "Region": "المنطقة",
      "SelectPharmacy": "اختر الصيدلية",
      "Search_for_an_area...": "ابحث عن منطقة...",
      "+AddMedicine": "+ إضافة دواء",
      "User": "المستخدم",
      "HI_USER": "مرحباً، @name",
      "Success": "نجاح",
      "Error": "خطأ",
      "DELIVERY_DATE": "تاريخ التوصيل",

      // Delivery Card
      "SCHEDULE": "الجدول الزمني",
      "INVENTORY": "المخزون",
      "DeliveredSuccessfully": "تم التوصيل بنجاح",
      "InTransit...": "جاري التوصيل...",
      "StartDelivery": "بدء التوصيل",
      "LOW": "منخفض",
      "NORMAL": "طبيعي",
      "URGENT": "عاجل",
      "ITEMS_PRICE_SUMMARY": "@count عناصر · @price ل.س",
      "EST_TIME": "الوقت المتوقع: @time",
      "ASSIGNED_TIME": "تم التعيين: @time",
      "LanguageEditing": "تعديل اللغة",

      // Medicine Card
      "Add_to_cart": "إضافة إلى السلة",
      "Alternatives": "البدائل",
      "QTY_STOCK": "الكمية: @stock",
      "UNIT_PRICE_SP": "سعر القطعة: @price ل.س",
      "Remove": "إزالة",

      // Drawer Home
      "Privacy_Policy": "سياسة الخصوصية",
      "Logout": "تسجيل الخروج",
      "Share_Application": "مشاركة التطبيق",
      "Theme_Toggle": "تغيير المظهر",
      "Support": "الدعم الفني",
      "Application_language": "لغة التطبيق",
      "My_Targets": "أهدافي (التارغيت)",
      "My_Profile": "ملفي الشخصي",
      "MySitting": "إعداداتي",
      "IntelliPharma": "إنتيلي فارما",
      "Active_Offers": "العروض النشطة",
      "Plan_Today's_Route": "تخطيط مسار\nاليوم",
      "TeamMember": "عضو الفريق",
      "ORDER_ID": "طلب رقم @id",
      "PENDING": "قيد الانتظار",
      "VISITED": "تمت الزيارة",
      "Closed": "مغلق",
      "Open": "مفتوح",
      "PHARMACIST_NAME": "الصيدلي: @name",

      // Order Priority Extension
      "IN_TRANSIT": "جاري التوصيل",
      "DELIVERED": "تم التسليم",
      "ORDER_NUMBER": "طلب رقم @number",

      // Pharmacy Route Dialog
      "ROUTE_TO_PHARMACY": "المسار إلى @name",

      // Pharmacy Summary Card
      "SCHEDULED_VISIT": "زيارة مجدولة",
      "CLOSED": "مغلق",
      "OPEN_NOW": "مفتوح الآن",
      "HOLIDAY_LABEL": "العطلة: @text",

      // PlanRouteCard
      "Today's_planned_visits": "زيارات اليوم المخططة",
      "PlanToday'sRoute": "خطط لمسار اليوم",

      // Route Step Item
      "Visit_Details": "تفاصيل الزيارة",
      "GIFT_QUANTITY": "كمية الهدية: @gift",
      "UNITS_COUNT": "@count وحدة",

      "Walking": "مشي",
      "Driving": "قيادة",

      //Active Delivery RouteScreen
      "NoCurrentDataPath": "لا توجد بيانات مسار حالية",
      "DELIVERY_TIMELINE": "الجدول الزمني للتسليم",
      "The_map_is_being_created...": "يتم إنشاء الخريطة...",
      "ORDER_REFERENCE": "رقم الطلب",
      "ORDER_REFERENCE_VALUE": "#ORD-@orderId",
      "REGION_NAME": "المنطقة: @region",
      "ETA_ORDER": "وقت الوصول المتوقع @eta • الطلب #@orderId",

      'privacy_policy_title': 'سياسة الخصوصية',
      'privacy_policy_content': '''
نحن في IntelliPharma نولي أهمية كبيرة لخصوصية بياناتك وحمايتها. تهدف هذه السياسة إلى توضيح كيفية جمع واستخدام بياناتك عند استخدام التطبيق.

     1. البيانات التي نجمعها:
     • معلومات الحساب: مثل الاسم، رقم الهاتف، والدور الوظيفي (مندوب / موزع).
     • بيانات الموقع الجغرافي (GPS): يُستخدم تحديد الموقع الجغرافي لتحديد مواقع الصيدليات المسجلة وتسهيل تنظيم وخطة الزيارات والتوصيل.
     • الصور والمرفقات: في حال رفع صور الصيدليات أو المستندات والطلبيات.

     2. كيفية استخدام البيانات:
     • تنظيم وتحديث مسارات الزيارات والتوصيل اليومية.
     • إدارة الطلبيات والحسابات المالية المتعلقة بالصيدليات.
     • تحسين تجربة المستخدم وأداء التطبيق.

     3. مشاركة البيانات:
     • نلتزم بعدم بيع أو مشاركة بياناتك مع أي أطراف تجارية خارجية.
     • تُستخدم البيانات حصراً ضمن نطاق إدارة العمليات والمستودع.

     4. أمان البيانات:
     • نطبق إجراءات أمان تقنية مناسبة لحماية بياناتك من الوصول غير المصرح به.

     5. التواصل والدعم:
     • في حال كان لديك أي استفسار حول سياسة الخصوصية، يمكنك التواصل معنا عبر قسم الدعم الفني في التطبيق.
     ''',
      "IntelliPharma_Privacy_&_Security": "خصوصية وأمن إنتلي فارما",
      "Search...": "ابحث...",
      "All_Categories": "جميع الفئات",
      "NoNotifications": "لا يوجد إشعارات",
      "Notifications": "الإشعارات",
      "DeliveryConfirmation": "تأكيد التسليم",
      "Start_of_visit": "بداية الزيارة",
      "Change_status": "تغيير الحالة",
      "Change_visit_status": "تغيير حالة الزيارة",
      "Choose_the_reason_for_non-completion...": "اختر سبب عدم الاتمام...",
      "Enter_additional_notes_(optional)...":
          "أدخل ملاحظات إضافية (اختياري)...",
      "Please_select_the_reason_first.": "يرجى اختيار السبب أولا",
      'pharmacy_closure': 'الصيدلية مغلقة',
      'traffic_jam': 'ازدحام مروري',
      'official_holiday': 'عطلة رسمية',
      'weather_conditions': 'ظروف جوية',
      'pharmacist_delay': 'تأخير من الصيدلي',
      'status_blocked': 'محظور',
      'status_failed': 'فشل',
      'status_skipped': 'تخطي',
      "WHY_ARE_YOU_RE-PLANNING": "لماذا تُعيد التخطيط؟",
      "Enter_the_reason_for_re-planning...": "أدخل سبب إعادة التخطيط...",
      "Submit": "إرسال",
      "Cancel": "إلغاء",
      'road_closure': 'الطرق مغلق',
      'accident_ahead': 'حادث أمامي',
      'pharmacy_closed': 'الصيدلية مغلقة',
      'schedule_change': 'تغيير في الجدول',
      'other': 'سبب آخر',
      "PROOF_OF_DELIVERY": "إثبات التسليم",
      "Take_Photo": "التقاط صورة",
      "Tap_to_capture_parcel": "اضغط لالتقاط صورة للطرد",
      "RECEIVER_NAME": "اسم المستلم",
      "PAYMENT_AMOUNT_(OPTIONAL)": "مبلغ الدفع (اختياري)",
      "CHECK_NOTES_(OPTIONAL)": "ملاحظات الفحص (اختياري)",
      "Add_any_delivery_satisfaction_notes":
          "أضف أي ملاحظات حول رضا المستلم عن عملية التسليم",
      "Recipient's_name": "اسم المستلم",
      "Processing...": "جارٍ المعالجة...",
      "EditOrder": "تعديل الطلب",
      "No_items_in_order": "لا توجد عناصر بالترتيب",
      "AddNewMedicine": "إضافة دواء جديد",
      "SaveChanges": "حفظ التغييرات",
      "AddMedicineToOrder": "أضف الدواء إلى طلبك",
      "OnTheWay": "في الطريق",

      "TOTAL_OUTSTANDING_BALANCE": "إجمالي الرصيد المتبقي",
      "Total_Billed": "إجمالي الفواتير",
      "Total_Paid": "إجمالي المدفوع",
      "amount_sp": "@amount ل.س",
      "percent_collected": "تم تحصيل @percent%",
      "percent_remaining": "متبقي @percent%",
      "OVERDUE": "متأخر",
      "PARTIAL": "جزئي",
      "PAID": "مدفوع",
      "filter_all": "الكل",
      "filter_fully_paid": "مدفوع بالكامل",
      "filter_partially_paid": "مدفوع جزئياً",
      "filter_pending": "قيد الانتظار",
      "filter_overdue": "متأخر",
      "pharmacies_outstanding_summary": "@count صيدليات - المتبقي @amount ل.س",
      "Remaining": "المتبقي",
      "Paid": "المدفوع",
      "percent_paid": "تم دفع @percent%",
      "last_payment_date": "آخر دفعة: @date",
      "No_debts_or_records_found": "لا توجد ديون أو سجلات حالياً",
      "Record_Payment": "تسجيل دفعة",
      "Invoices/Orders": "الفواتير / الطلبات",
      "Payments": "الدفعات",
      "Last_Payment": "آخر دفعة",
      "Remaining_Balance": "الرصيد المتبقي",
      "payment_amount": "+@amount ل.س",
      "ref_label": "رقم المرجع:",
      "collected_by_label": "تم التحصيل بواسطة:",
      "balance_after_label": "الرصيد بعد الدفعة:",
      "balance_amount_sp": "@amount ل.س",
      "no_payments_found": "لا توجد دفعات مسجلة حالياً",
      "paid_uppercase": "المدفوع",
      "remaining_uppercase": "المتبقي",
      "no_invoices_found": "لا توجد فواتير أو طلبات حالياً",
      //payment Screen
      "record_payment_title": "تسجيل دفعة",
      "outstanding_balance_label": "الرصيد المتبقي",
      "payment_amount_label": "مبلغ الدفعة",
      "type_to_edit_hint": "انقر لتعديل قيمة الدفعة",
      "current_balance_label": "الرصيد الحالي",
      "payment_label": "الدفعة",
      "new_balance_label": "الرصيد الجديد",
      "payment_date_label": "تاريخ الدفع",
      "notes_optional_label": "ملاحظات (اختياري)",
      "add_payment_context_hint": "إضافة ملاحظات أو تفاصيل الدفعة...",
      "confirm_payment_btn": "تأكيد الدفع",
      "invalid_amount_err": "الرجاء إدخال مبلغ صحيح",
      "payment_success_msg": "تم تسجيل الدفعة بنجاح",
      "Are_you_sure_you_want_to_logout?":"هل أنت متأكد من رغبتك في تسجيل الخروج؟",
      "No":"لا",
      "Yes":"نعم",
      //ProfileScreen
      'Representative Profile': 'ملف المندوب',
      'Senior Sales Representative': 'مندوب مبيعات أول',
      'NORTH REGION': 'المنطقة الشمالية',
      'CONTACT': 'تواصل',
      'Active Clients': 'العملاء النشطون',
      'Orders this month': 'طلبات هذا الشهر',
      'Average Deal Size': 'متوسط حجم الصفقة',
      'Performance Targets': 'أهداف الأداء',
      'MONTHLY PROGRESS': 'التقدم الشهري',
      'QUARTERLY PROGRESS': 'التقدم الربع سنوي',
      'of': 'من',
      'achieved': 'مُحقق',
      'failed_to_load_profile': 'فشل تحميل بيانات البروفايل',
      'Monthly Sales Target': 'هدف المبيعات الشهرية',
      'Quarterly Sales Target': 'هدف المبيعات الربع سنوية',
       //Medicine Details Screen
      'Medicine_Details': 'تفاصيل الدواء',
      'PRICE_PER_UNIT': 'سعر الوحدة',
      'STOCK_AVAILABLE': 'المخزون المتاح',
      'MANUFACTURER': 'المصنّع',
      'BARCODE': 'الباركود',
      'Failed_to_load_details': 'فشل تحميل تفاصيل الدواء',
      "units":"وحدات",
      "SP":"ل.س",
      'No_Offers_Available': 'لا توجد عروض أو هدايا متاحة على هذا الدواء',
      'No_Alternatives_Available': 'لا توجد بدائل متاحة لهذا الدواء حالياً',
      'OFF': 'خصم',
      'GIFT': 'هدية',
      'DiscountOffer': 'عرض خصم',
      'FreeGift': 'هدية مجانية',
      'MinOrder': 'الحد الأدنى للطلب',
      "Items": "@items عناصر",
      "Cancel_Order":"إلغاء الطلب",
      "Are_you_sure_cancel_order":"هل أنت متأكد من إلغاء الطلب؟",
      "DELETE_CART_QUESTION":"هل تريد حذف السلة؟",
      "CONFIRM_EXIT":"تأكيد الخروج",
    },
  };
}
