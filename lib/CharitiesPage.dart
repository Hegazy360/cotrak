import 'package:cached_network_image/cached_network_image.dart';
import 'package:cotrak/AppLocalizations.dart';
import 'package:cotrak/WebViewContainer.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

const List charities = [
  {
    'name': 'Feeding America',
    'description':
        'Has a Covid-19 Response Fund that is helping to ensure food banks across the country can feed those in need right now, including the children who rely on school meals to eat.',
    'imageUrl':
        'https://www.feedingamerica.org/themes/custom/ts_feeding_america/images/sprite-logo2018.png',
    'url': 'https://www.feedingamerica.org/'
  },
  {
    'name': 'Doctors Without Borders',
    'description':
        'Is sending aid to the countries hit hardest by Covid-19 and strengthening the infection controls in its already established programs, as well as maintaining existing help in the 70-plus countries it regularly assists.',
    'imageUrl':
        'https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/24882312210439.562651c5e83fe.jpg',
    'url': 'https://www.doctorswithoutborders.org/'
  },
  {
    'name': 'The World Health Organization',
    'description':
        'Is coordinating efforts across the world to respond to existing cases and prevent the novel coronavirus from spreading.',
    'imageUrl':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/World_Health_Organization_Logo.svg/1280px-World_Health_Organization_Logo.svg.png',
    'url':
        'https://www.who.int/emergencies/diseases/novel-coronavirus-2019/donate'
  },
  {
    'name': 'Oxfam America',
    'description':
        'Is organizing efforts to increase the delivery of clean water and sanitary supplies to refugees and those living in higher-risk environments.',
    'imageUrl':
        'https://landportal.org/sites/landportal.org/files/styles/220heightmax/public/OUS_Logo_h_green.png?itok=yTKb8xlD',
    'url': 'https://www.oxfamamerica.org/explore/emergencies/COVID-19/'
  },
  {
    'name': 'The Red Cross',
    'description':
        "Is in desperate need of blood donations if you're in a position to do so.",
    'imageUrl':
        'https://i.pinimg.com/originals/75/9f/f9/759ff92884237a32a82e6f49b86c0aac.png',
    'url': 'https://www.redcrossblood.org'
  },
  {
    'name': 'World Central Kitchen',
    'description': 'is delivering chef-prepared meals to those in need.',
    'imageUrl':
        'https://i2.wp.com/ewnews.com/wp-content/uploads/2019/09/worldcentralkitchen.jpeg?fit=720%2C380&ssl=1',
    'url': 'https://wck.org/chefsforamerica'
  },
  {
    'name': 'Team Rubicon',
    'description':
        'A veteran-based company that provides services during natural disasters and emergencies, has assembled teams across the country to help with logistics, packaging and distributing food, and even supplementing hotline staffing.',
    'imageUrl':
        'https://www.teamrubiconuk.org/wp-content/uploads/2018/10/TeamRubicon_primary_red_compressed-1024x490.png',
    'url': 'https://teamrubiconusa.org/neighbors/'
  },
  {
    'name': 'Vitamin Angels',
    'description':
        'Is a nonprofit which helps undernourished pregnant women and babies at risk of malnutrition.',
    'imageUrl':
        'https://www.newhope.com/sites/newhope360.com/files/styles/article_featured_retina/public/vitamin-angels-logo.jpg?itok=pfNCPLE0',
    'url': 'https://www.vitaminangels.org/'
  },
];

class CharitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding:
          const EdgeInsets.only(left: 30.0, right: 30.0, top: 60.0, bottom: 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('charities_title'),
            style: TextStyle(
                fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            AppLocalizations.of(context).translate('charities_subtitle'),
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              AppLocalizations.of(context).translate('charities_subtitle2'),
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: charities.length,
              itemBuilder: (BuildContext context, int index) {
                return buildCharityCard(charities[index], context);
              },
            ),
          )
        ],
      ),
    );
  }

  Container buildCharityCard(charity, context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebViewContainer(
                          charity['url'], "Back To Charities")));
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Text(
                          charity['name'],
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      )),
                      CachedNetworkImage(
                        imageUrl: charity['imageUrl'],
                        imageBuilder: (context, imageProvider) => Image(
                          image: imageProvider,
                          height: 50,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  ),
                ),
                Text(charity['description']),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: FlatButton.icon(
              icon: Icon(LineIcons.external_link),
              label: Text("Go To Website"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebViewContainer(
                            charity['url'], "Back To Charities")));
              },
            ),
          )
        ],
      ),
    );
  }
}
