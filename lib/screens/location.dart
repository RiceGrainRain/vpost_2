import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vpost_2/resources/autocomplate_prediction.dart';
import 'package:vpost_2/resources/firestore_methods.dart';
import 'package:vpost_2/resources/maps_network_method.dart';
import 'package:vpost_2/resources/place_auto_complate_response.dart';
import 'package:vpost_2/responsive/mobile_screen_layout.dart';
import 'package:vpost_2/responsive/responsive_layout.dart';
import 'package:vpost_2/responsive/web_layout.dart';
import 'package:vpost_2/utils/colors.dart';
import 'package:vpost_2/utils/global_variables.dart';
import 'package:vpost_2/widgets/home/location_tile.dart';

class UserLocationUpdate extends StatefulWidget {
  const UserLocationUpdate({super.key});

  @override
  State<UserLocationUpdate> createState() => _UserLocationUpdateState();
}

class _UserLocationUpdateState extends State<UserLocationUpdate> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController _locationController = TextEditingController();
  List<AutocompletePrediction> placePredictions = [];

  void placeAutocomplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      'maps/api/place/autocomplete/json',
      {
        "input": query,
        "key": apiKey,
      },
    );
    String? response = await NetworkUtility.fetchUrl(uri);

    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Add your location'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              FireStoreMethods()
                  .updateLocation(currentUser.uid, _locationController.text);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout(),
                  ),
                ),
              );
            },
            child: const Text(
              "Next",
              style: TextStyle(
                  color: greenColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.88,
                child: TextFormField(
                  onChanged: (value) {
                    placeAutocomplete(value);
                  },
                  textAlignVertical: TextAlignVertical.center,
                  controller: _locationController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.arrow_forward_ios,
                      color: primaryColor,
                      size: 14,
                    ),
                    hintText: 'Add Location',
                    border: InputBorder.none,
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const Divider(
            color: primaryColor,
            thickness: 1,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: placePredictions.length, // Use placePredictions
            itemBuilder: (context, index) => LocationTile(
              location: placePredictions[index].description!,
              press: () {
                setState(() {
                  _locationController.text =
                      placePredictions[index].description!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
