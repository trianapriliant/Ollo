import 'pattern_base.dart';

const Map<String, CategoryPattern> mandarinPatterns = {
  // --- EXPENSE ---
  'Food & Drink': CategoryPattern(
    mainKeywords: ['餐饮', '吃饭', '食品', '食物', '饭'],
    subCategoryKeywords: {
      'Breakfast': ['早餐', '早饭', '早点'],
      'Lunch': ['午餐', '午饭', '中饭'],
      'Dinner': ['晚餐', '晚饭', '宵夜'],
      'Eateries': [
        '餐厅', '饭馆', '餐馆', '食堂', '咖啡厅', '肯德基', '麦当劳', '必胜客', '星巴克'
      ],
      'Snacks': ['零食', '小吃', '点心', '雪糕', '巧克力', '糖果', '饼干'],
      'Drinks': [
        '饮料', '水', '奶茶', '咖啡', '果汁', '啤酒', '可乐', '雪碧'
      ],
      'Groceries': [
        '超市', '买菜', '菜市场', '便利店', '杂货', '水果', '蔬菜', '肉', '蛋', '米'
      ],
      'Delivery': ['外卖', '美团', '饿了么', '配送费'],
      'Alcohol': ['酒', '白酒', '红酒', '啤酒', '酒吧'],
    },
  ),
  'Housing': CategoryPattern(
    mainKeywords: ['居住', '房', '住'],
    subCategoryKeywords: {
      'Rent': [
        '房租', '租金', '押金', '中介费', '订金',
        '月租', '合租', '短租', '管理费'
      ],
      'Mortgage': [
        '房贷', '按揭', '还贷', '公积金还贷', '月供', '利息'
      ],
      'Utilities': [
        '水电费', '电费', '水费', '燃气费', '暖气费', '物业费',
        '天然气', '煤气费', '取暖费', '垃圾处理费'
      ],
      'Internet': [
        '网费', '宽带', '话费', '流量', '光纤', 'Wifi',
        '移动', '联通', '电信', '套餐费', '手机充值'
      ],
      'Maintenance': [
        '维修', '装修', '家具维修', '疏通', '换锁',
        '家电维修', '漏水', '墙面粉刷'
      ],
      'Furniture': [
        '家具', '家电', '床', '沙发', '桌椅', '衣柜', '窗帘',
        '床垫', '地毯', '灯具', '宜家'
      ],
      'Services': [
        '家政', '保洁', '保安费', '物业管理', '小时工'
      ],
    },
  ),
  'Shopping': CategoryPattern(
    mainKeywords: ['购物', '买东西'],
    subCategoryKeywords: {
      'Clothes': [
        '衣服', '服装', '鞋子', '裤子', '外套', '内衣', '裙子',
        '衬衫', '毛衣', '卫衣', '羽绒服', '西装', '牛仔裤',
        '运动鞋', '皮鞋', '包包', '帽子', '围巾',
        '优衣库', 'ZARA', 'H&M', '淘宝', '天猫', '唯品会'
      ],
      'Electronics': [
        '电子产品', '手机', '电脑', '数码', '耳机',
        '笔记本', '平板', '充电器', '数据线', '音箱',
        '相机', '冰箱', '洗衣机', '空调', '电视',
        '苹果', '华为', '小米', '京东', '苏宁'
      ],
      'Home': [
        '日用品', '生活用品', '杂货', '纸巾', '洗衣液',
        '洗发水', '沐浴露', '牙膏', '清洁剂',
        '名创优品', '超市购物', '宜家家居'
      ],
      'Beauty': [
        '美容', '化妆品', '理发', '护肤', '美发',
        '口红', '面膜', '粉底', '香水', '防晒',
        '剪发', '烫发', '染发', '美甲', 'SPA',
        '屈臣氏', '丝芙兰'
      ],
      'Gifts': [
        '礼物', '礼品', '红包', '伴手礼', '生日礼物',
        '节日礼物', '礼金'
      ],
      'Software': [
        '软件', 'APP', '订阅', '会员', '充值',
        '爱奇艺', '腾讯视频', '百度网盘', 'QQ音乐', '网易云',
        'Steam', 'App Store'
      ],
      'Tools': [
        '工具', '文具', '五金', '电池', '灯泡', '螺丝刀'
      ],
    },
  ),
  'Transport': CategoryPattern(
    mainKeywords: ['交通', '出行'],
    subCategoryKeywords: {
      'Bus': ['公交', '巴士'],
      'Train': ['地铁', '火车', '高铁', '轻轨'],
      'Taxi': ['打车', '出租车', '滴滴', '网约车'],
      'Fuel': ['加油', '油费', '汽油'],
      'Parking': ['停车', '停车费'],
      'Maintenance': ['修车', '保养', '洗车'],
      'Insurance': ['车险'],
      'Toll': ['过路费', '高速费'],
    },
  ),
  'Entertainment': CategoryPattern(
    mainKeywords: ['娱乐', '玩'],
    subCategoryKeywords: {
      'Movies': ['电影', '看电影'],
      'Games': ['游戏', '充值', '网吧'],
      'Streaming': ['视频会员', '音乐会员'],
      'Events': ['演出', '演唱会', '门票'],
      'Hobbies': ['爱好', '摄影', '画画'],
      'Travel': ['旅游', '旅行', '机票', '酒店', '住宿'],
      'Music': ['音乐', 'KTV'],
    },
  ),
  'Health': CategoryPattern(
    mainKeywords: ['健康', '医疗'],
    subCategoryKeywords: {
      'Doctor': ['看病', '挂号', '医院', '医生'],
      'Pharmacy': ['买药', '药店', '药品'],
      'Gym': ['健身', '运动', '游泳', '瑜伽'],
      'Insurance': ['医保', '保险'],
      'Mental Health': ['心理咨询'],
      'Sports': ['体育', '球类'],
    },
  ),
  'Education': CategoryPattern(
    mainKeywords: ['教育', '学习'],
    subCategoryKeywords: {
      'Tuition': ['学费', '培训费'],
      'Books': ['书', '教材', '买书'],
      'Courses': ['课程', '补习'],
      'Supplies': ['文具', '学习用品'],
    },
  ),
  'Family': CategoryPattern(
    mainKeywords: ['家庭', '孩子'],
    subCategoryKeywords: {
      'Childcare': ['育儿', '保姆', '幼儿园'],
      'Toys': ['玩具'],
      'School': ['学校', '学杂费'],
      'Pets': ['宠物', '猫粮', '狗粮'],
    },
  ),
  'Financial': CategoryPattern(
    mainKeywords: ['金融'],
    subCategoryKeywords: {
      'Taxes': ['税', '税费'],
      'Fees': ['手续费'],
      'Fines': ['罚款'],
      'Insurance': ['保险费'],
    },
  ),
  'Personal': CategoryPattern(
    mainKeywords: ['个人'],
    subCategoryKeywords: {
      'Haircut': ['理发', '剪发'],
      'Spa': ['按摩', 'SPA', '桑拿'],
      'Cosmetics': ['化妆品'],
    },
  ),
  'Friend': CategoryPattern(
    mainKeywords: ['朋友', '好友', '伙伴'],
    subCategoryKeywords: {
      'Transfer': ['转给朋友', '转账朋友', '给朋友转'],
      'Treat': ['请客', '请朋友吃饭', '买单', '请客吃饭', '我请客'],
      'Refund': ['还朋友钱', '还钱给朋友'],
      'Loan': ['借给朋友', '朋友借钱', '借出'],
      'Gift': ['送朋友', '朋友礼物', '给朋友买礼物'],
    },
  ),

  // --- INCOME ---

  'Salary': CategoryPattern(
    mainKeywords: ['工资', '收入'],
    subCategoryKeywords: {
      'Monthly': ['月薪', '发工资'],
      'Weekly': ['周薪'],
      'Bonus': ['奖金', '红包'],
      'Overtime': ['加班费'],
    },
  ),
  'Business': CategoryPattern(
    mainKeywords: ['生意'],
    subCategoryKeywords: {
      'Sales': ['销售', '卖货'],
      'Services': ['服务费'],
      'Profit': ['利润'],
    },
  ),
  'Investments': CategoryPattern(
    mainKeywords: ['投资', '理财'],
    subCategoryKeywords: {
      'Dividends': ['分红'],
      'Interest': ['利息'],
      'Crypto': ['数字货币', '比特币'],
      'Stocks': ['股票', '基金'],
      'Real Estate': ['房租收入'],
    },
  ),
  'Gifts': CategoryPattern(
    mainKeywords: ['收到礼物'],
    subCategoryKeywords: {
      'Birthday': ['生日红包'],
      'Holiday': ['节日红包', '压岁钱'],
      'Allowance': ['零花钱', '生活费'],
    },
  ),
  'Other': CategoryPattern(
    mainKeywords: ['其他收入'],
    subCategoryKeywords: {
      'Refunds': ['退款'],
      'Grants': ['补贴', '补助'],
      'Lottery': ['中奖', '彩票'],
      'Selling': ['二手', '闲鱼'],
    },
  ),
};
