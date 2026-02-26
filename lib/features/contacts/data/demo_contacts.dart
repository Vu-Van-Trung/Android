import '../models/contact_model.dart';

// Flag để toggle demo data
const bool useDemoData = true;

// Demo contacts data với variety để test different scenarios
final List<Contact> demoContacts = [
  const Contact(
    id: '1',
    name: 'Nguyễn Văn An',
    phoneNumber: '+84 905 123 456',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    isOnline: true,
    lastSeen: null,
  ),
  const Contact(
    id: '2',
    name: 'Trần Thị Bình',
    phoneNumber: '+84 912 345 678',
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
    isOnline: false,
    lastSeen: '2 giờ trước',
  ),
  const Contact(
    id: '3',
    name: 'Lê Hoàng Cường',
    phoneNumber: '+84 909 876 543',
    avatarUrl: null, // No avatar case
    isOnline: true,
    lastSeen: null,
  ),
  const Contact(
    id: '4',
    name: 'Phạm Thị Diệu Hằng',
    phoneNumber: '+84 918 765 432',
    avatarUrl: 'https://i.pravatar.cc/150?img=9',
    isOnline: false,
    lastSeen: 'Hôm qua',
  ),
  const Contact(
    id: '5',
    name: 'Võ Minh Em',
    phoneNumber: '+84 903 456 789',
    avatarUrl: null, // No avatar case
    isOnline: false,
    lastSeen: '3 ngày trước',
  ),
  const Contact(
    id: '6',
    name: 'Đặng Quốc Phong',
    phoneNumber: '+84 907 111 222',
    avatarUrl: 'https://i.pravatar.cc/150?img=33',
    isOnline: true,
    lastSeen: null,
  ),
  const Contact(
    id: '7',
    name: 'Bùi Thị Giang',
    phoneNumber: '+84 915 333 444',
    avatarUrl: 'https://i.pravatar.cc/150?img=24',
    isOnline: true,
    lastSeen: null,
  ),
];
