import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String speed = 'Slow';
  TextEditingController pagesController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  double day = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Reading Time Estimator'),
        backgroundColor: Colors.tealAccent,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade100, Colors.lightBlue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            width: 350,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Image.asset('assets/book.png', scale: 2),
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome to Book Reading Time Estimator!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: pagesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Total Number of Pages',
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: hoursController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Hours per Day',
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        'Reading Speed:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    DropdownButton<String>(
                      value: speed,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      items: <String>['Slow', 'Average', 'Fast'].map((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        speed = newValue!;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => calculation(speed),
                      child: Text('Calculate', style: TextStyle(fontSize: 20)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        pagesController.clear();
                        hoursController.clear();
                        setState(() {
                          speed = 'Slow';
                          day = 0.0;
                        });
                      },
                      child: Text('Reset', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'You will finish in ${day.toStringAsFixed(1)} days.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calculation(String speed) {
    //validate input
    String pagesText = pagesController.text;
    String hoursText = hoursController.text;

    // Check if fields are empty
    if (pagesText.isEmpty || hoursText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    // Check if input is valid numbers
    if (int.tryParse(pagesText) == null || double.tryParse(hoursText) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers.')),
      );
      return;
    }

    // Check if hours > 0
    double hours = double.parse(hoursText);
    if (hours <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hours per day must be greater than 0.')),
      );
      return;
    }

    //calculations

    int pages = int.parse(pagesController.text);
    double hoursPerDay = double.parse(hoursController.text);
    double readingSpeed;

    if (speed == 'Slow') {
      readingSpeed = 20.0; // pages per hour
    } else if (speed == 'Average') {
      readingSpeed = 40.0; // pages per hour
    } else {
      readingSpeed = 60.0; // pages per hour
    }

    if (hoursPerDay > 0) {
      double totalHours = pages / readingSpeed;
      day = totalHours / hoursPerDay;
    } else {
      day = 0.0;
    }
    setState(() {});
  }
}
