import 'package:flutter/material.dart';

const url = 'http://www.gstatic.com/tv/thumb/persons/673351/673351_v9_ba.jpg';

class PlayersInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10.0),
        child: ListView(
          children: <Widget>[
            PlayerInfoCard(),
            PlayerInfoCard(),
            PlayerInfoCard(),
            PlayerInfoCard(),
            PlayerInfoCard(),
            PlayerInfoCard(),
            PlayerInfoCard(),
            PlayerInfoCard(),
            PlayerInfoCard(),
            PlayerInfoCard(),
            PlayerInfoCard(),
            PlayerInfoCard(),
            PlayerInfoCard(),
            PlayerInfoCard(),
            PlayerInfoCard(),
            PlayerInfoCard(),
            PlayerInfoCard(),
            PlayerInfoCard(),
          ],
        ));
  }
}

class PlayerInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(5.0),
        // margin: EdgeInsets.all(10.0),
        child: InkWell(
          // highlightColor: Colors.blue,
          onTap: () {
            print('it works');
          },
          child: Row(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(
                      top: 10.0, bottom: 10.0, right: 5.0, left: 5.0),
                  child: CircleAvatar(
                    radius: 35.0,
                    backgroundImage: NetworkImage(
                      url,
                      // width: 100.0,
                      // height: 100.0,
                      // fit: BoxFit.cover,
                    ),
                  )),
              Container(
                  height: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Cristiano Ronaldo',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Text('Juventus')
                      ])),
            ],
          ),
        ));
  }
}
