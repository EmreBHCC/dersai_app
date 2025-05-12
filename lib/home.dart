import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> notes = [];
  Map<String, Color> noteColors = {};
  final List<Color> availableColors = [
    Color.fromARGB(255, 90, 186, 255), // Açık mavi
    Color.fromARGB(255, 172, 120, 255), // Açık mor
    Color.fromARGB(255, 124, 255, 135), // Açık yeşil
    Color.fromARGB(255, 255, 204, 121), // Açık turuncu
    Color.fromARGB(255, 255, 124, 248), // Açık pembe
    Color.fromARGB(255, 121, 239, 255), // Açık turkuaz
    Color.fromARGB(255, 255, 117, 138), // Açık kırmızı
  ];

  Color getRandomColor() {
    return availableColors[DateTime.now().millisecondsSinceEpoch %
        availableColors.length];
  }

  Color darken(Color color, [double amount = .4]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  void _addNote() async {
    String? newNote = await showDialog<String>(
      context: context,
      builder: (context) {
        String input = "";
        return AlertDialog(
          title: Text('Yeni Not Ekle'),
          content: TextField(
            autofocus: true,
            onChanged: (value) => input = value,
            decoration: InputDecoration(hintText: 'Not başlığı girin'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(input),
              child: Text('Ekle'),
            ),
          ],
        );
      },
    );

    if (newNote != null && newNote.isNotEmpty) {
      setState(() {
        notes.add(newNote);
        noteColors[newNote] = getRandomColor();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              MyAppBar(text: "Notlarim"),
              SizedBox(height: 20),
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Notlariniz", style: TextStyle(fontSize: 25)),
                    SizedBox(width: 20),
                    Container(
                      width: 178,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 1),
                      ),
                      child: InkWell(
                        onTap: _addNote,
                        borderRadius: BorderRadius.circular(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Yeni not ekle"),
                            IconButton(
                              onPressed: _addNote,
                              icon: Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 80,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    final baseColor = noteColors[note]!;
                    return Stack(
                      children: [
                        // En alttaki gölgeli katman
                        Positioned(
                          top: 16,
                          right: 0,
                          left: 16,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 65, 65, 65),
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                        ),
                        // Ortadaki gölgeli katman
                        Positioned(
                          top: 8,
                          right: 0,
                          left: 8,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 31, 31, 31),
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                        ),
                        // Asıl not kartı
                        Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [baseColor, darken(baseColor, 0.4)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 0,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  note,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Color(0xff02003C),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/direct_tanima');
                },
                child: Center(
                  child: Text(
                    'Doğrudan Tanıma',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyAppBar extends StatelessWidget {
  final String text;
  const MyAppBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 412,
      height: 98,
      decoration: BoxDecoration(color: Color(0xff02003C)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.menu, color: Colors.white),
                ),
                Text(text, style: TextStyle(color: Colors.white, fontSize: 25)),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.circle_outlined, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
