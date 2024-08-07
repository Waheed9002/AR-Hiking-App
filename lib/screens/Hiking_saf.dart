import 'package:flutter/material.dart';

class HikingTips extends StatelessWidget {
  const HikingTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Tips'),
        backgroundColor: Colors.white10,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Hiking Safety Tips',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5)
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/tips up.jpg',
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Before you set out on your hike, make sure to carefully read and implement these essential safety tips. By following these guidelines, you’ll help ensure a safe and enjoyable journey. Each tip is designed to keep you well-prepared for your adventure. Don’t skip any of them!',
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 30),
            _buildTipCard(
              context,
              title: 'Ensure Your Phone is Charged',
              image: 'assets/emg/charging.jpg',
              points: [
                'Charge your phone fully before starting your hike.',
                'Consider bringing a portable charger or power bank.',
                'Use your phone sparingly to preserve battery life for emergencies.',
              ],
            ),
            _buildTipCard(
              context,
              title: 'Plan Ahead',
              image: 'assets/emg/plan.jpeg',
              points: [
                'Know your trail and its difficulty level.',
                'Check the weather forecast and be prepared for changes.',
                'Inform someone about your plans and expected return time.',
              ],
            ),
            _buildTipCard(
              context,
              title: 'Carry Essentials',
              image: 'assets/emg/essential.jpg',
              points: [
                'Bring enough water and snacks for the duration of the hike.',
                'Pack a first aid kit and emergency supplies.',
                'Carry a map, compass, or GPS device.',
              ],
            ),
            _buildTipCard(
              context,
              title: 'Wear Appropriate Gear',
              image: 'assets/emg/gear.jpg',
              points: [
                'Wear sturdy, comfortable hiking boots.',
                'Dress in layers to adapt to changing weather conditions.',
                'Use a hat and sunscreen to protect against sun exposure.',
              ],
            ),
            _buildTipCard(
              context,
              title: 'Be Aware of Wildlife',
              image: 'assets/emg/aware.jpg',
              points: [
                'Keep a safe distance from animals.',
                'Do not feed wildlife.',
                'Store food securely and away from sleeping areas.',
              ],
            ),
            _buildTipCard(
              context,
              title: 'Emergency Preparedness',
              image: 'assets/emg/emergncy.jpg',
              points: [
                'Know the nearest medical facilities and emergency contacts.',
                'Learn basic first aid and how to use your first aid kit.',
                'In case of emergency, call 112 (Europe) or 911 (US) for assistance.',
                'Carry a whistle or mirror to signal for help if needed.',
              ],
            ),
            _buildTipCard(
              context,
              title: 'Stay on Marked Trails',
              image: 'assets/emg/mrktrail.jpeg',
              points: [
                'Stick to designated trails to avoid getting lost.',
                'Follow trail markers and signs to navigate safely.',
                'Respect private property and restricted areas.',
              ],
            ),
            _buildTipCard(
              context,
              title: 'Leave No Trace',
              image: 'assets/emg/lvnotrace.gif',
              points: [
                'Pack out all trash and belongings.',
                'Do not disturb wildlife or remove plants.',
                'Leave the environment as you found it for others to enjoy.',
              ],
            ),
            _buildTipCard(
              context,
              title: 'Group Safety',
              image: 'assets/emg/safety.png',
              points: [
                'Hike with a group if possible for added safety.',
                'Keep track of group members, especially in challenging areas.',
                'Establish meeting points and check-in times if separated.',
              ],
            ),
            _buildTipCard(
              context,
              title: 'Know Your Limits',
              image: 'assets/emg/Limit.jpg',
              points: [
                'Choose trails that match your fitness level and experience.',
                'Rest when needed and stay hydrated.',
                'Do not overexert yourself; turn back if necessary.',
              ],
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Remember, safety should always be our top priority when hiking. Plan thoroughly, be prepared, and stay informed to ensure a safe and enjoyable experience.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, {required String title, required String image, required List<String> points}) {
    return Card(
      color: Colors.grey[200],
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                image,
                width: MediaQuery.of(context).size.width * 0.9,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: points.map((point) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.teal),
                      const SizedBox(width: 10),
                      Expanded(child: Text(point, style: const TextStyle(fontSize: 16), textAlign: TextAlign.justify)),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
