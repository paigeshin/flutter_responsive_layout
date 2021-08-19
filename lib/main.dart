import 'package:adaptive_layout/people.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      /** *AdaptiveLayout #1* => Wrap Widget with LayoutBuilder **/
      body: LayoutBuilder(
        builder: (context, constraints) {
          /** *AdaptiveLayout #2* => Wrap Widget with LayoutBuilder **/
          if (constraints.maxWidth > 600) {
            return WideLayout();
            // TODO insert a layout between 400 and 600 that is
          } else {
            return NarrowLayout();
          }
        },
      ),
    );
  }
}

class WideLayout extends StatefulWidget {
  @override
  _WideLayoutState createState() => _WideLayoutState();
}

class _WideLayoutState extends State<WideLayout> {
  Person? _person;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: PeopleList(
              onPersonTap: (person) => setState(
                () => _person = person,
              ),
            ),
          ),
          width: 200,
        ),
        Expanded(
          child: _person == null ? Placeholder() : PersonDetail(_person!),
          flex: 3,
        ),
      ],
    );
  }
}

class NarrowLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PeopleList(
      onPersonTap: (person) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(),
            body: PersonDetail(
              person,
            ),
          ),
        ),
      ),
    );
  }
}

class PeopleList extends StatelessWidget {
  final void Function(Person) onPersonTap;

  const PeopleList({required this.onPersonTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          for (var person in people)
            ListTile(
              // leading: Image.network(
              //   person.picture,
              // ),
              title: Text(
                person.name,
              ),
              onTap: () => onPersonTap(person),
            ),
        ],
      ),
    );
  }
}

class PersonDetail extends StatelessWidget {
  final Person person;

  const PersonDetail(this.person);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxHeight > 200) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MouseRegion(
                  child: Text(
                    person.name,
                  ),
                  onHover: (event) => {print('Hello World')},
                ),
                SizedBox(
                  height: 16,
                ),
                Text(person.phone),
                SizedBox(
                  height: 16,
                ),
                MaterialButton(
                  onPressed: () {},
                  color: Colors.black,
                  textColor: Colors.white,
                  child: Text('Contact Me'),
                )
              ],
            ),
          );
        } else {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(person.name),
                Text(person.phone),
                MaterialButton(
                  onPressed: () {},
                  color: Colors.black,
                  textColor: Colors.white,
                  child: Text('Contact Me'),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
