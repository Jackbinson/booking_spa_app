import '../core/constants/app_assets.dart';
import '../models/spa_service.dart';

const List<String> serviceCategories = [
  'Tất cả',
  'Massage',
  'Chăm sóc da',
  'Gội đầu',
  'Trị liệu',
];

const List<String> defaultBenefits = [
  'Giảm căng thẳng',
  'Thư giãn cơ thể',
  'Cải thiện giấc ngủ',
];

const List<String> defaultProcess = [
  'Xông tinh dầu',
  'Massage toàn thân',
  'Nghỉ ngơi và dùng trà',
];

const List<SpaService> mockServices = [
  SpaService(
    id: 'massage-body',
    name: 'Massage body thư giãn',
    category: 'Massage',
    description:
        'Liệu trình massage toàn thân với tinh dầu thiên nhiên giúp giảm đau mỏi, thả lỏng cơ và phục hồi năng lượng.',
    price: 350000,
    durationMinutes: 60,
    image: AppAssets.massage,
    rating: 4.8,
    isPopular: true,
    tag: 'Phổ biến',
    benefits: defaultBenefits,
    process: defaultProcess,
  ),
  SpaService(
    id: 'basic-facial',
    name: 'Chăm sóc da cơ bản',
    category: 'Chăm sóc da',
    description:
        'Làm sạch sâu, tẩy tế bào chết và cấp ẩm nhẹ nhàng cho làn da tươi sáng hơn.',
    price: 300000,
    durationMinutes: 45,
    image: AppAssets.facial,
    rating: 4.7,
    isPopular: true,
    tag: 'Phổ biến',
    benefits: ['Sạch sâu', 'Dưỡng ẩm', 'Da mềm mịn'],
    process: ['Tẩy trang', 'Làm sạch da', 'Đắp mặt nạ dưỡng ẩm'],
  ),
  SpaService(
    id: 'herbal-hair-wash',
    name: 'Gội đầu dưỡng sinh',
    category: 'Gội đầu',
    description:
        'Gội đầu thảo dược kết hợp massage đầu, cổ, vai gáy để giảm mệt mỏi sau ngày dài.',
    price: 180000,
    durationMinutes: 45,
    image: AppAssets.hairWash,
    rating: 4.9,
    isPopular: false,
    tag: 'Mới',
    benefits: ['Giảm đau đầu', 'Thư giãn vai gáy', 'Tóc mềm hơn'],
    process: ['Chải huyệt vùng đầu', 'Gội thảo dược', 'Massage cổ vai gáy'],
  ),
  SpaService(
    id: 'acne-care',
    name: 'Trị mụn chuyên sâu',
    category: 'Trị liệu',
    description:
        'Quy trình làm sạch, lấy nhân mụn chuẩn vệ sinh và làm dịu da bằng sản phẩm chuyên dụng.',
    price: 550000,
    durationMinutes: 90,
    image: AppAssets.acneCare,
    rating: 4.6,
    isPopular: false,
    tag: 'Khuyến mãi',
    benefits: ['Giảm viêm', 'Sạch lỗ chân lông', 'Hỗ trợ phục hồi da'],
    process: ['Soi da', 'Làm sạch và lấy nhân mụn', 'Đắp mặt nạ làm dịu'],
  ),
  SpaService(
    id: 'hot-stone',
    name: 'Massage đá nóng',
    category: 'Massage',
    description:
        'Kết hợp massage thư giãn và đá nóng để làm dịu vùng cơ căng cứng, cải thiện tuần hoàn.',
    price: 450000,
    durationMinutes: 75,
    image: AppAssets.hotStone,
    rating: 4.8,
    isPopular: false,
    tag: '',
    benefits: ['Giảm đau mỏi', 'Lưu thông máu', 'Thư thái tinh thần'],
    process: ['Làm nóng cơ thể', 'Massage đá nóng', 'Thưởng trà thư giãn'],
  ),
  SpaService(
    id: 'deep-facial',
    name: 'Chăm sóc da chuyên sâu',
    category: 'Chăm sóc da',
    description:
        'Chăm sóc da chuyên sâu với tinh chất phục hồi, phù hợp làn da thiếu ẩm và mệt mỏi.',
    price: 500000,
    durationMinutes: 90,
    image: AppAssets.facial,
    rating: 4.8,
    isPopular: false,
    tag: '',
    benefits: ['Cấp ẩm sâu', 'Da sáng khỏe', 'Giảm mệt mỏi cho da'],
    process: ['Làm sạch', 'Massage mặt', 'Ủ tinh chất phục hồi'],
  ),
];
