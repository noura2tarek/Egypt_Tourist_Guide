import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/governorate_model.dart';
import 'models/place_model.dart';

// List of Governorates
final List<GovernorateModel> GOVERNERATES =const[
  GovernorateModel(
    id: '1',
    name: 'Alexandria',
    description: 'A historic Mediterranean port city in Egypt.',
    // Use one image for Alexandria

    image:
        'assets/cities/alexandria/stanley_bridge2.jpg', // Use one image for Alexandria
  ),
  GovernorateModel(
    id: '2',
    name: 'Cairo',
    description:
        'The bustling capital of Egypt, home to ancient wonders and modern attractions.',

    image: 'assets/cities/cairo/cairo.jpg', // Use one image for Cairo
  ),
  GovernorateModel(
    id: '3',
    name: 'Giza',

    description:
        'The world-famous for the Pyramids of Giza, the Great Sphinx, and the Giza Plateau..',
    image: 'assets/cities/giza/pyramids.jpg', // Use one image for Giza
  ),
   GovernorateModel(
    id: '4',
    name: 'Hurghada',
    description:
        'A popular Red Sea resort town known for its beaches and diving spots.',
    image: 'assets/cities/hurghada/hurghada.jpg', // Use one image for Hurghada
  ),
   GovernorateModel(
    id: '5',
    name: 'Luxor',

    description:
        'Known as the world\'s greatest open-air museum, with ancient temples and tombs.',
    image: 'assets/cities/luxor/luxor.jpg', // Use one image for Luxor
  ),
];

// Places positions
final Map<String, dynamic> placesPositions = {
  'Corniche': const GeoPoint(31.2156, 29.9060),
  'Library of Alexandria': const GeoPoint(31.2089, 29.9092),
  'Quitbai Citadel': const GeoPoint(31.2140, 29.8856),
  'Cairo Tower': const GeoPoint(30.0459, 31.2243),
  'Elmoez Street': const GeoPoint(30.0505, 31.2613),
  'Mosque of Muhammad Ali': const GeoPoint(30.0286, 31.2599),
  'Pyramids of Giza': const GeoPoint(29.9792, 31.1342),
  'Sphinx': const GeoPoint(29.9753, 31.1376),
  'El Gouna': const GeoPoint(27.4025, 33.6515),
  'Hurghada Grand Aquarium': const GeoPoint(27.1215, 33.8281),
  'Karnak Temple': const GeoPoint(25.7188, 32.6573),
  'Colossi of Memnon': const GeoPoint(25.7204, 32.6100),
};
// List of Places
final List<PlacesModel> PLACES = [
  PlacesModel(
    id: 1,
    governorateId: '1',
    // Alexandria
    name: 'Corniche',
    description: 'A scenic waterfront promenade in Alexandria.',
    image: 'assets/cities/alexandria/corniche.jpg',
    isFav: false,
    location: placesPositions['Corniche'],
  ),
  PlacesModel(
    id: 2,
    governorateId: '1',
    // Alexandria
    name: 'Library of Alexandria',
    description:
        'A modern library and cultural center commemorating the ancient Library of Alexandria.',
    image: 'assets/cities/alexandria/library_of_alexandria.jpg',
    isFav: false,
    location: placesPositions['Library of Alexandria'],
  ),
  PlacesModel(
    id: 3,
    governorateId: '1',
    // Alexandria
    name: 'Quitbai Citadel',
    description: 'A historic fortress located on the Mediterranean coast.',
    image: 'assets/cities/alexandria/quitbai_citidal.jpg',
    isFav: false,
    location: placesPositions['Quitbai Citadel'],
  ),
  PlacesModel(
    id: 4,
    governorateId: '2',
    // Cairo
    name: 'Cairo Tower',
    description: 'A iconic tower offering panoramic views of Cairo.',
    image: 'assets/cities/cairo/cairo_tower.webp',
    isFav: false,
    location: placesPositions['Cairo Tower'],
  ),
  PlacesModel(
    id: 5,
    governorateId: '2',
    // Cairo
    name: 'Elmoez Street',
    description:
        'A historic street in Islamic Cairo with stunning architecture.',
    image: 'assets/cities/cairo/elmoez_street.jpg',
    isFav: false,
    location: placesPositions['Elmoez Street'],
  ),
  PlacesModel(
    id: 6,
    governorateId: '2',
    // Cairo
    name: 'Mosque of Muhammad Ali',
    description:
        'A stunning Ottoman-style mosque located in the Cairo Citadel.',
    image: 'assets/cities/cairo/mosque_of_muhammad_ali.webp',
    isFav: false,
    location: placesPositions['Mosque of Muhammad Ali'],
  ),
  PlacesModel(
    id: 7,
    governorateId: '3',
    // Giza
    name: 'Pyramids of Giza',
    description: 'The last remaining wonder of the ancient world.',
    image: 'assets/cities/giza/pyramids.jpg',
    isFav: false,
    location: placesPositions['Pyramids of Giza'],
  ),
  PlacesModel(
    id: 8,
    governorateId: '3',
    // Giza
    name: 'Sphinx',
    description:
        'A mythical creature with the body of a lion and the head of a human.',
    image: 'assets/cities/giza/sphinx_and_pyramid_in_giza.jpeg',
    isFav: false,
    location: placesPositions['Sphinx'],
  ),
  PlacesModel(
    id: 9,
    governorateId: '4',
    // Hurghada
    name: 'El Gouna',
    description: 'A luxurious resort town on the Red Sea.',
    image: 'assets/cities/hurghada/el_gouna_festival_plaza.jpeg',
    isFav: false,
    location: placesPositions['El Gouna'],
  ),
  PlacesModel(
    id: 10,
    governorateId: '4',
    // Hurghada
    name: 'Hurghada Grand Aquarium',
    description: 'A large aquarium showcasing marine life from the Red Sea.',
    image: 'assets/cities/hurghada/hurghada_grand_aquarium.jpg',
    isFav: false,
    location: placesPositions['Hurghada Grand Aquarium'],
  ),
  PlacesModel(
    id: 11,
    governorateId: '5',
    // Luxor
    name: 'Karnak Temple',
    description: 'A vast temple complex dedicated to the god Amun.',
    image: 'assets/cities/luxor/karnak_temple.jpg',
    isFav: false,
    location: placesPositions['Karnak Temple'],
  ),
  PlacesModel(
    id: 12,
    governorateId: '5',
    // Luxor
    name: 'Colossi of Memnon',
    description: 'Two massive stone statues of Pharaoh Amenhotep III.',
    image: 'assets/cities/luxor/colossi_of_memnon.jpg',
    isFav: false,
    location: placesPositions['Colossi of Memnon'],
  ),
];

final List<GovernorateModel> ARABICGOVERNORATES = [
  GovernorateModel(
    id: '1',
    name: 'الإسكندرية',
    description: 'مدينة ساحلية تاريخية على البحر المتوسط في مصر.',
    image: 'assets/cities/alexandria/stanley_bridge2.jpg',
  ),
  GovernorateModel(
    id: '2',
    name: 'القاهرة',
    description: 'عاصمة مصر الصاخبة، موطن العجائب القديمة والمعالم الحديثة.',
    image: 'assets/cities/cairo/cairo.jpg',
  ),
  GovernorateModel(
    id: '3',
    name: 'الجيزة',
    description: 'تشتهر بأهرامات الجيزة، أبو الهول، وهضبة الجيزة.',
    image: 'assets/cities/giza/pyramids.jpg',
  ),
  GovernorateModel(
    id: '4',
    name: 'الغردقة',
    description:
        'مدينة منتجعية شهيرة على البحر الأحمر معروفه بشواطئها وأماكن الغوص.',
    image: 'assets/cities/hurghada/hurghada.jpg',
  ),
  GovernorateModel(
    id: '5',
    name: 'الأقصر',
    description:
        'تُعرف بأنها أكبر متحف مفتوح في العالم، مع المعابد والمقابر القديمة.',
    image: 'assets/cities/luxor/luxor.jpg',
  ),
];

// قائمة الأماكن (List of Places)
final List<PlacesModel> ARABICPLACES = [
  PlacesModel(
    id: 1,
    governorateId: '1',
    // الإسكندرية
    name: 'الكورنيش',
    description: 'واجهة بحرية خلابة في الإسكندرية.',
    image: 'assets/cities/alexandria/corniche.jpg',
    isFav: false,
    location: placesPositions['Corniche'],
  ),
  PlacesModel(
    id: 2,
    governorateId: '1',
    // الإسكندرية
    name: 'مكتبة الإسكندرية',
    description: 'مكتبة حديثة ومركز ثقافي لإحياء ذكرى المكتبة القديمة.',
    image: 'assets/cities/alexandria/library_of_alexandria.jpg',
    isFav: false,
    location: placesPositions['Library of Alexandria'],
  ),
  PlacesModel(
    id: 3,
    governorateId: '1',
    // الإسكندرية
    name: 'قلعة قايتباي',
    description: 'قلعة تاريخية تقع على ساحل البحر المتوسط.',
    image: 'assets/cities/alexandria/quitbai_citidal.jpg',
    isFav: false,
    location: placesPositions['Quitbai Citadel'],
  ),
  PlacesModel(
    id: 4,
    governorateId: '2',
    // القاهرة
    name: 'برج القاهرة',
    description: 'برج أيقوني يوفر إطلالة بانورامية على القاهرة.',
    image: 'assets/cities/cairo/cairo_tower.webp',
    isFav: false,
    location: placesPositions['Cairo Tower'],
  ),
  PlacesModel(
    id: 5,
    governorateId: '2',
    // القاهرة
    name: 'شارع المعز',
    description: 'شارع تاريخي في القاهرة الإسلامية يتميز بالعمارة الرائعة.',
    image: 'assets/cities/cairo/elmoez_street.jpg',
    isFav: false,
    location: placesPositions['Elmoez Street'],
  ),
  PlacesModel(
    id: 6,
    governorateId: '2',
    // القاهرة
    name: 'مسجد محمد علي',
    description: 'مسجد رائع على الطراز العثماني يقع في قلعة القاهرة.',
    image: 'assets/cities/cairo/mosque_of_muhammad_ali.webp',
    isFav: false,
    location: placesPositions['Mosque of Muhammad Ali'],
  ),
  PlacesModel(
    id: 7,
    governorateId: '3',
    // الجيزة
    name: 'أهرامات الجيزة',
    description: 'آخر عجائب الدنيا السبع الباقية من العالم القديم.',
    image: 'assets/cities/giza/pyramids.jpg',
    isFav: false,
    location: placesPositions['Pyramids of Giza'],
  ),
  PlacesModel(
    id: 8,
    governorateId: '3',
    // الجيزة
    name: 'أبو الهول',
    description: 'تمثال أسطوري بجسم أسد ورأس إنسان.',
    image: 'assets/cities/giza/sphinx_and_pyramid_in_giza.jpeg',
    isFav: false,
    location: placesPositions['Sphinx'],
  ),
  PlacesModel(
    id: 9,
    governorateId: '4',
    // الغردقة
    name: 'الجونة',
    description: 'مدينة منتجعية فاخرة على البحر الأحمر.',
    image: 'assets/cities/hurghada/el_gouna_festival_plaza.jpeg',
    isFav: false,
    location: placesPositions['El Gouna'],
  ),
  PlacesModel(
    id: 10,
    governorateId: '4',
    // الغردقة
    name: 'أكواريوم الغردقة',
    description: 'أكواريوم كبير يعرض الحياة البحرية في البحر الأحمر.',
    image: 'assets/cities/hurghada/hurghada_grand_aquarium.jpg',
    isFav: false,
    location: placesPositions['Hurghada Grand Aquarium'],
  ),
  PlacesModel(
    id: 11,
    governorateId: '5',
    // الأقصر
    name: 'معبد الكرنك',
    description: 'مجمع معابد ضخم مخصص للإله آمون.',
    image: 'assets/cities/luxor/karnak_temple.jpg',
    isFav: false,
    location: placesPositions['Karnak Temple'],
  ),
  PlacesModel(
    id: 12,
    governorateId: '5',
    // الأقصر
    name: 'تمثالي ممنون',
    description: 'تمثالان ضخمان من الحجر للفرعون أمنحتب الثالث.',
    image: 'assets/cities/luxor/colossi_of_memnon.jpg',
    isFav: false,
    location: placesPositions['Colossi of Memnon'],
  ),
];
