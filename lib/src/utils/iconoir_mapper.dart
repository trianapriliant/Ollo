import 'package:flutter/material.dart' hide Key, Page;
import 'package:iconoir_flutter/iconoir_flutter.dart';

/// Maps icon names to Iconoir widgets.
/// Returns a Widget for the given icon name, with customizable size and color.
class IconoirMapper {
  static Widget getIcon(String iconName, {double size = 24, Color? color}) {
    final effectiveColor = color ?? Colors.grey[600];
    
    switch (iconName.toLowerCase().trim()) {
      // Finance & Wallet
      case 'account_balance_wallet':
      case 'wallet':
      case 'money':
      case 'cash':
        return Wallet(width: size, height: size, color: effectiveColor);
      case 'account_balance':
        return Bank(width: size, height: size, color: effectiveColor);
      case 'credit_card':
        return CreditCard(width: size, height: size, color: effectiveColor);
      case 'payments':
        return HandCash(width: size, height: size, color: effectiveColor);
      case 'savings':
      case 'saving':
        return PiggyBank(width: size, height: size, color: effectiveColor);
      case 'monetization_on':
        return Dollar(width: size, height: size, color: effectiveColor);
      case 'currency_exchange':
        return RefreshDouble(width: size, height: size, color: effectiveColor);
      case 'transfer':
      case 'swap_horiz':
      case 'compare_arrows':
        return DataTransferBoth(width: size, height: size, color: effectiveColor);
      case 'send_money':
      case 'send':
        return SendDiagonal(width: size, height: size, color: effectiveColor);
      case 'account_box':
        return UserSquare(width: size, height: size, color: effectiveColor);
      case 'attach_money':
        return Dollar(width: size, height: size, color: effectiveColor);
      case 'trending_up':
        return StatUp(width: size, height: size, color: effectiveColor);
      case 'trending_down':
        return StatDown(width: size, height: size, color: effectiveColor);
      case 'pie_chart':
        return StatsReport(width: size, height: size, color: effectiveColor); // Changed from PieChart
      case 'currency_bitcoin':
        return BitcoinCircle(width: size, height: size, color: effectiveColor);

      // Shopping & Retail
      case 'shopping_bag':
        return ShoppingBag(width: size, height: size, color: effectiveColor);
      case 'shopping_cart':
      case 'local_grocery_store':
      case 'groceries':
        return Cart(width: size, height: size, color: effectiveColor);
      case 'store':
        return Shop(width: size, height: size, color: effectiveColor);
      case 'local_mall':
        return Shop(width: size, height: size, color: effectiveColor);
      case 'redeem':
      case 'card_giftcard':
        return Gift(width: size, height: size, color: effectiveColor);
      case 'sell':
        return Bookmark(width: size, height: size, color: effectiveColor); // Changed from Tag
      case 'checkroom':
        return Shirt(width: size, height: size, color: effectiveColor);
      case 'shopping_basket':
        return Cart(width: size, height: size, color: effectiveColor);

      // Transport & Travel
      case 'directions_car':
      case 'local_taxi':
      case 'transport':
        return Car(width: size, height: size, color: effectiveColor);
      case 'directions_bus':
        return Bus(width: size, height: size, color: effectiveColor);
      case 'flight':
        return Airplane(width: size, height: size, color: effectiveColor);
      case 'train':
        return Train(width: size, height: size, color: effectiveColor);
      case 'two_wheeler':
        return Motorcycle(width: size, height: size, color: effectiveColor);
      case 'directions_bike':
        return Bicycle(width: size, height: size, color: effectiveColor);
      case 'directions_boat':
        return SeaWaves(width: size, height: size, color: effectiveColor);
      case 'local_gas_station':
        return GasTank(width: size, height: size, color: effectiveColor);
      case 'commute':
        return Tram(width: size, height: size, color: effectiveColor);
      case 'directions_walk':
        return Walking(width: size, height: size, color: effectiveColor);
      case 'directions_run':
        return Running(width: size, height: size, color: effectiveColor);
      case 'local_parking':
      case 'parking':
        return Parking(width: size, height: size, color: effectiveColor);
      case 'toll':
        return DashFlag(width: size, height: size, color: effectiveColor);
      case 'card_travel':
        return Suitcase(width: size, height: size, color: effectiveColor);

      // Home & Living
      case 'home':
      case 'house':
      case 'cottage':
        return Home(width: size, height: size, color: effectiveColor);
      case 'info':
        return InfoCircle(width: size, height: size, color: effectiveColor);
      case 'folder':
        return Folder(width: size, height: size, color: effectiveColor);
      case 'help':
        return HelpCircle(width: size, height: size, color: effectiveColor);
      case 'restore':
        return Undo(width: size, height: size, color: effectiveColor);
      case 'file_download':
        return Download(width: size, height: size, color: effectiveColor);
      case 'file_upload':
        return Upload(width: size, height: size, color: effectiveColor);
      case 'send':
        return ShareAndroid(width: size, height: size, color: effectiveColor);
      case 'search':
        return Search(width: size, height: size, color: effectiveColor);
      case 'filter':
        return FilterList(width: size, height: size, color: effectiveColor);
      case 'apartment':
        return Building(width: size, height: size, color: effectiveColor);
      case 'weekend':
      case 'chair':
        return Sofa(width: size, height: size, color: effectiveColor);
      case 'bank':
        return Bank(width: size, height: size, color: effectiveColor);
      case 'bitcoin':
        return BitcoinCircle(width: size, height: size, color: effectiveColor);
      case 'credit_card':
        return CreditCard(width: size, height: size, color: effectiveColor);
      case 'copy':
        return Copy(width: size, height: size, color: effectiveColor);
      case 'copy_all':
        return MultiplePagesEmpty(width: size, height: size, color: effectiveColor);
      case 'sort_by_alpha':
        return SortDown(width: size, height: size, color: effectiveColor);
      case 'push_pin':
        return Pin(width: size, height: size, color: effectiveColor);
      case 'delete':
        return Trash(width: size, height: size, color: effectiveColor);
      case 'person':
        return User(width: size, height: size, color: effectiveColor);
      case 'business_center':
        return Suitcase(width: size, height: size, color: effectiveColor);
      case 'numbers':
        return Hashtag(width: size, height: size, color: effectiveColor);
      case 'person_outline':
        return User(width: size, height: size, color: effectiveColor);
      case 'label':
        return Label(width: size, height: size, color: effectiveColor);
      case 'location':
        return MapPin(width: size, height: size, color: effectiveColor);
      case 'keyboard_arrow_down':
        return NavArrowDown(width: size, height: size, color: effectiveColor);
      case 'kitchen':
        return Bonfire(width: size, height: size, color: effectiveColor); // Changed from Oven
      case 'lightbulb':
        return LightBulb(width: size, height: size, color: effectiveColor);
      case 'water_drop':
        return Droplet(width: size, height: size, color: effectiveColor);
      case 'wifi':
        return Wifi(width: size, height: size, color: effectiveColor);
      case 'build':
      case 'construction':
        return Tools(width: size, height: size, color: effectiveColor);
      case 'cleaning_services':
        return Spark(width: size, height: size, color: effectiveColor);
      case 'bolt':
        return Flash(width: size, height: size, color: effectiveColor);

      // Food & Drink
      case 'fastfood':
      case 'food':
        return Bbq(width: size, height: size, color: effectiveColor);
      case 'restaurant':
        return Cutlery(width: size, height: size, color: effectiveColor);
      case 'lunch_dining':
        return Bbq(width: size, height: size, color: effectiveColor);
      case 'dinner_dining':
        return PizzaSlice(width: size, height: size, color: effectiveColor);
      case 'eateries':
        return ShopFourTiles(width: size, height: size, color: effectiveColor);
      case 'local_cafe':
      case 'coffee':
        return CoffeeCup(width: size, height: size, color: effectiveColor);
      case 'local_bar':
        return GlassHalf(width: size, height: size, color: effectiveColor);
      case 'liquor':
        return GlassEmpty(width: size, height: size, color: effectiveColor);
      case 'local_pizza':
        return PizzaSlice(width: size, height: size, color: effectiveColor);
      case 'bakery_dining':
        return Cookie(width: size, height: size, color: effectiveColor);
      case 'icecream':
        return IceCream(width: size, height: size, color: effectiveColor);
      case 'cake':
        return BirthdayCake(width: size, height: size, color: effectiveColor);
      case 'delivery':
      case 'delivery_dining':
        return DeliveryTruck(width: size, height: size, color: effectiveColor);

      // Health & Wellness
      case 'medical_services':
        return Heart(width: size, height: size, color: effectiveColor); // Changed from FirstAid
      case 'local_hospital':
        return Hospital(width: size, height: size, color: effectiveColor);
      case 'local_pharmacy':
        return Hospital(width: size, height: size, color: effectiveColor); // Changed from Pharmacy
      case 'fitness_center':
        return Gym(width: size, height: size, color: effectiveColor);
      case 'pool':
        return Swimming(width: size, height: size, color: effectiveColor);
      case 'spa':
        return Flower(width: size, height: size, color: effectiveColor); // Changed from Spa
      case 'monitor_heart':
        return Heart(width: size, height: size, color: effectiveColor);
      case 'healing':
        return Heart(width: size, height: size, color: effectiveColor); // Changed from Bandaid
      case 'self_improvement':
        return Yoga(width: size, height: size, color: effectiveColor);

      // Entertainment & Leisure
      case 'movie':
        return Movie(width: size, height: size, color: effectiveColor);
      case 'sports_esports':
      case 'gamepad':
        return Gamepad(width: size, height: size, color: effectiveColor);
      case 'music_note':
        return MusicNote(width: size, height: size, color: effectiveColor);
      case 'camera_alt':
        return Camera(width: size, height: size, color: effectiveColor);
      case 'live_tv':
        return ModernTv(width: size, height: size, color: effectiveColor);
      case 'theater_comedy':
        return Star(width: size, height: size, color: effectiveColor); // Changed from Mask
      case 'sports_soccer':
      case 'sports_football':
        return Football(width: size, height: size, color: effectiveColor);
      case 'sports_basketball':
        return Basketball(width: size, height: size, color: effectiveColor);
      case 'sports_tennis':
        return TennisBall(width: size, height: size, color: effectiveColor); // Changed from Tennis
      case 'sports_golf':
        return Golf(width: size, height: size, color: effectiveColor);
      case 'sports_volleyball':
        return Basketball(width: size, height: size, color: effectiveColor); // Changed from Volleyball
      case 'headphones':
        return Headset(width: size, height: size, color: effectiveColor);
      case 'chat_bubble':
        return ChatBubble(width: size, height: size, color: effectiveColor);
      case 'camera_alt':
        return Camera(width: size, height: size, color: effectiveColor);
      case 'mic_outline':
        return Microphone(width: size, height: size, color: effectiveColor);
      case 'casino':
        return DiceSix(width: size, height: size, color: effectiveColor);
      case 'palette':
      case 'brush':
        return ColorPicker(width: size, height: size, color: effectiveColor);
      case 'piano':
        return MusicDoubleNote(width: size, height: size, color: effectiveColor);
      case 'mic':
        return Microphone(width: size, height: size, color: effectiveColor);
      case 'kitesurfing':
      case 'surfing':
        return SeaWaves(width: size, height: size, color: effectiveColor);
      case 'hiking':
        return Trekking(width: size, height: size, color: effectiveColor);

      // Nature & Outdoors
      case 'forest':
      case 'park':
        return PineTree(width: size, height: size, color: effectiveColor); // Changed from Tree
      case 'terrain':
      case 'landscape':
        return PineTree(width: size, height: size, color: effectiveColor); // Changed from Mountains
      case 'beach_access':
        return SeaWaves(width: size, height: size, color: effectiveColor);
      case 'wb_sunny':
        return SunLight(width: size, height: size, color: effectiveColor);
      case 'nightlight':
        return MoonSat(width: size, height: size, color: effectiveColor);
      case 'local_florist':
        return Flower(width: size, height: size, color: effectiveColor);
      case 'grass':
      case 'eco':
        return Leaf(width: size, height: size, color: effectiveColor);
      case 'pets':
        return Wolf(width: size, height: size, color: effectiveColor);
      case 'apple':
      case 'fruits':
        return Apple(width: size, height: size, color: effectiveColor);

      // People & Family
      case 'person':
        return User(width: size, height: size, color: effectiveColor);
      case 'people':
      case 'group':
      case 'groups':
        return Group(width: size, height: size, color: effectiveColor);
      case 'child_friendly':
      case 'baby_changing_station':
      case 'child_care':
        return Stroller(width: size, height: size, color: effectiveColor);
      case 'family_restroom':
        return Community(width: size, height: size, color: effectiveColor);
      case 'face':
      case 'mood':
        return EmojiSatisfied(width: size, height: size, color: effectiveColor);

      // Work & Education
      case 'work':
      case 'business_center':
        return Suitcase(width: size, height: size, color: effectiveColor);
      case 'school':
        return GraduationCap(width: size, height: size, color: effectiveColor);
      case 'courses':
        return BookStack(width: size, height: size, color: effectiveColor);
      case 'menu_book':
      case 'books':
        return Book(width: size, height: size, color: effectiveColor);
      case 'computer':
        return Computer(width: size, height: size, color: effectiveColor);
      case 'science':
        return Flask(width: size, height: size, color: effectiveColor);
      case 'calculate':
        return Calculator(width: size, height: size, color: effectiveColor);
      case 'architecture':
        return Ruler(width: size, height: size, color: effectiveColor);
      case 'engineering':
        return Settings(width: size, height: size, color: effectiveColor);
      case 'cast_for_education':
        return Book(width: size, height: size, color: effectiveColor);
      case 'backpack':
      case 'supplies':
        return Bag(width: size, height: size, color: effectiveColor);

      // Technology & Devices
      case 'smartphone':
        return Phone(width: size, height: size, color: effectiveColor);
      case 'laptop':
        return MacOsWindow(width: size, height: size, color: effectiveColor);
      case 'watch':
        return Wristwatch(width: size, height: size, color: effectiveColor);
      case 'router':
        return Wifi(width: size, height: size, color: effectiveColor);
      case 'devices':
      case 'electronics':
        return Computer(width: size, height: size, color: effectiveColor);
      case 'developer_board':
      case 'software':
        return Code(width: size, height: size, color: effectiveColor);

      // Menu Items
      case 'budget':
        return StatsReport(width: size, height: size, color: effectiveColor);
      case 'recurring':
        return Refresh(width: size, height: size, color: effectiveColor);
      case 'checklist':
        return Notes(width: size, height: size, color: effectiveColor);
      case 'savings_outlined':
        return PiggyBank(width: size, height: size, color: effectiveColor);
      case 'handshake_outlined':
        return HandCash(width: size, height: size, color: effectiveColor);
      case 'bills':
        return Page(width: size, height: size, color: effectiveColor);
      case 'wishlist':
        return Gift(width: size, height: size, color: effectiveColor);
      case 'cards':
        return CreditCard(width: size, height: size, color: effectiveColor);
      case 'reimburse':
        return RefreshDouble(width: size, height: size, color: effectiveColor);

      // System & Other
      case 'star':
        return Star(width: size, height: size, color: effectiveColor);
      case 'favorite':
        return Heart(width: size, height: size, color: effectiveColor);
      case 'lock':
        return Lock(width: size, height: size, color: effectiveColor);
      case 'key':
        return Key(width: size, height: size, color: effectiveColor);
      case 'delete':
        return Bin(width: size, height: size, color: effectiveColor);
      case 'receipt':
      case 'receipt_long':
        return Page(width: size, height: size, color: effectiveColor);
      case 'help':
      case 'help_outline':
        return HelpCircle(width: size, height: size, color: effectiveColor);
      case 'settings':
        return Settings(width: size, height: size, color: effectiveColor);
      case 'celebration':
        return Sparks(width: size, height: size, color: effectiveColor);
      case 'handshake':
      case 'debt':
      case 'debts':
        return HandCash(width: size, height: size, color: effectiveColor);
      case 'category':
        return Dashboard(width: size, height: size, color: effectiveColor);
      case 'calendar_month':
        return Calendar(width: size, height: size, color: effectiveColor);
      case 'monthly':
        return CalendarPlus(width: size, height: size, color: effectiveColor);
      case 'calendar_today':
        return CalendarCheck(width: size, height: size, color: effectiveColor);
      case 'calendar_view_week':
      case 'date_range':
        return CalendarMinus(width: size, height: size, color: effectiveColor);
      case 'weekly':
        return Timer(width: size, height: size, color: effectiveColor);
      case 'explore':
        return Compass(width: size, height: size, color: effectiveColor);
      case 'more_horiz':
        return MoreHoriz(width: size, height: size, color: effectiveColor);
      case 'tune':
      case 'adjustment':
        return ControlSlider(width: size, height: size, color: effectiveColor);
      case 'system':
      case 'settings_applications':
        return Settings(width: size, height: size, color: effectiveColor);
      case 'undo':
        return Undo(width: size, height: size, color: effectiveColor);
      case 'sort':
        return Sort(width: size, height: size, color: effectiveColor);

      // Additional mappings
      case 'bill':
        return Page(width: size, height: size, color: effectiveColor);
      case 'note':
      case 'notes':
      case 'smart note':
      case 'smart notes':
      case 'Smart Note':
      case 'Smart Notes':
      case 'edit_note':
        return Notes(width: size, height: size, color: effectiveColor);
      case 'car_repair':
      case 'maintenance':
        return Tools(width: size, height: size, color: effectiveColor);
      case 'plumbing':
        return Wrench(width: size, height: size, color: effectiveColor);
      case 'insurance':
      case 'security':
      case 'health_and_safety':
      case 'shield':
        return Shield(width: size, height: size, color: effectiveColor);
      case 'content_cut':
      case 'haircut':
        return Cut(width: size, height: size, color: effectiveColor);
      case 'event_seat':
      case 'events':
        return Calendar(width: size, height: size, color: effectiveColor);
      case 'gavel':
      case 'fines':
        return Crown(width: size, height: size, color: effectiveColor);
      case 'local_police':
        return Shield(width: size, height: size, color: effectiveColor);
      case 'toys':
        return Puzzle(width: size, height: size, color: effectiveColor);
      case 'access_time':
      case 'overtime':
      case 'more_time':
        return Clock(width: size, height: size, color: effectiveColor);
      case 'design_services':
      case 'services':
        return DesignPencil(width: size, height: size, color: effectiveColor);
      case 'show_chart':
      case 'stocks':
        return StatUp(width: size, height: size, color: effectiveColor);
      case 'real_estate':
      case 'real estate':
      case 'real_estate_agent':
      case 'domain':
        return Building(width: size, height: size, color: effectiveColor);
      case 'storefront':
      case 'selling':
        return Shop(width: size, height: size, color: effectiveColor);

      // Profile & Settings Unique Icons
      case 'download':
      case 'file_download':
        return Download(width: size, height: size, color: effectiveColor);
      case 'file_upload':
        return Upload(width: size, height: size, color: effectiveColor);
      case 'grid_view':
      case 'widgets':
        return ViewGrid(width: size, height: size, color: effectiveColor);
      case 'update':
        return Refresh(width: size, height: size, color: effectiveColor);
      case 'color_lens':
        return Palette(width: size, height: size, color: effectiveColor);
      case 'cloud_sync':
        return CloudSync(width: size, height: size, color: effectiveColor);
      case 'auto_awesome':
        return MagicWand(width: size, height: size, color: effectiveColor);
      case 'feedback':
      case 'chat_bubble_outline':
        return ChatBubbleEmpty(width: size, height: size, color: effectiveColor);
      case 'bug_report':
        return SystemRestart(width: size, height: size, color: effectiveColor); // Best match for Bug
      case 'info_outline':
        return InfoCircle(width: size, height: size, color: effectiveColor);
      case 'history':
        return Clock(width: size, height: size, color: effectiveColor);
      case 'delete_forever':
        return Trash(width: size, height: size, color: effectiveColor);
      case 'logout':
        return LogOut(width: size, height: size, color: effectiveColor);
      case 'rocket':
        return Rocket(width: size, height: size, color: effectiveColor);
      case 'chevron_right':
        return NavArrowRight(width: size, height: size, color: effectiveColor);
      case 'add':
        return Plus(width: size, height: size, color: effectiveColor);
      
      // Navigation Icons
      case 'close':
        return Xmark(width: size, height: size, color: effectiveColor);
      case 'arrow_back':
        return NavArrowLeft(width: size, height: size, color: effectiveColor);
      case 'arrow_forward':
        return NavArrowRight(width: size, height: size, color: effectiveColor);
      case 'arrow_upward':
        return ArrowUp(width: size, height: size, color: effectiveColor);
      case 'arrow_downward':
        return ArrowDown(width: size, height: size, color: effectiveColor);
      
      // Status Icons
      case 'check':
        return Check(width: size, height: size, color: effectiveColor);
      case 'check_circle':
        return CheckCircle(width: size, height: size, color: effectiveColor);
      case 'verified':
        return BadgeCheck(width: size, height: size, color: effectiveColor);
      case 'refresh':
        return Refresh(width: size, height: size, color: effectiveColor);
      
      // Language & Globe
      case 'language':
      case 'globe':
        return Globe(width: size, height: size, color: effectiveColor);
      
      // Premium/VIP Icons
      case 'workspace_premium':
        return Crown(width: size, height: size, color: effectiveColor);
      case 'code':
        return Code(width: size, height: size, color: effectiveColor);
      case 'analytics':
        return StatsReport(width: size, height: size, color: effectiveColor);
      case 'document_scanner':
      case 'scan':
        return ScanQrCode(width: size, height: size, color: effectiveColor);
      case 'support_agent':
        return Headset(width: size, height: size, color: effectiveColor);
      case 'all_inclusive':
        return Infinite(width: size, height: size, color: effectiveColor);

      // Default fallback
      default:
        return HelpCircle(width: size, height: size, color: effectiveColor);
    }
  }
}
