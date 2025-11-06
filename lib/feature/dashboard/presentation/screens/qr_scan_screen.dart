// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class QRScanScreen extends StatefulWidget {
//   const QRScanScreen({super.key});
//   @override
//   State<QRScanScreen> createState() => _QRScanScreenState();
// }
//
// class _QRScanScreenState extends State<QRScanScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Scan QR')),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 4,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//             ),
//           ),
//           Expanded(
//               flex: 1,
//               child: Center(
//                   child: ElevatedButton(
//                     child: const Text('Back'),
//                     onPressed: () {
//                       controller?.dispose();
//                       Navigator.of(context).pop();
//                     },
//                   ))),
//         ],
//       ),
//     );
//   }
//
//   void _onQRViewCreated(QRViewController c) {
//     controller = c;
//     c.scannedDataStream.listen((scanData) async {
//       // Example: QR payload might be "punch:start" or "punch:stop"
//       final payload = scanData.code ?? '';
//       final timer = Provider.of<TimerProvider>(context, listen: false);
//       if (payload.startsWith('punch:')) {
//         final action = payload.split(':')[1];
//         if (action == 'start') {
//           timer.start();
//           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Timer started')));
//         } else if (action == 'pause') {
//           timer.pause();
//           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Timer paused')));
//         } else if (action == 'stop') {
//           // stop requires title/desc -> show dialog then stop
//           _showStopDialog(timer);
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unrecognized QR')));
//       }
//       await Future.delayed(const Duration(milliseconds: 500));
//     });
//   }
//
//   void _showStopDialog(TimerProvider timer) {
//     final titleCtl = TextEditingController();
//     final descCtl = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Save interval (QR stop)'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(controller: titleCtl, decoration: const InputDecoration(labelText: 'Title')),
//             TextField(controller: descCtl, decoration: const InputDecoration(labelText: 'Description')),
//           ],
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () async {
//               final title = titleCtl.text.trim();
//               final desc = descCtl.text.trim();
//               Navigator.of(ctx).pop();
//               await timer.stopAndSave(title: title.isEmpty ? 'QR stop' : title, description: desc);
//               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved via QR')));
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
