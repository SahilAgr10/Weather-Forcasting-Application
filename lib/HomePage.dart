import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

import 'constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(API_KEY);
  Weather? _weather;
  String _cityName = "Delhi"; // default city name

  @override
  void initState() {
    super.initState();
    _wf.currentWeatherByCityName(_cityName).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(3, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF8BC34A), // Light Green
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(-3, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF03A9F4), // Light Blue
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, -1.2),
                child: Container(
                  height: 300,
                  width: 600,
                  decoration: const BoxDecoration(
                    color: Color(0xFF001524), // Amber
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                ),
              ),
              SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text(
                          '📍 ${_weather?.areaName ?? ""}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),///city name
                          GestureDetector(
                              onTap:  () async {
                                final city = await _showCityDialog(context);
                                if (city != null) {
                                  setState(() {
                                    _cityName = city;
                                  });
                                  _wf.currentWeatherByCityName(_cityName).then((w) {
                                    setState(() {
                                      _weather = w;
                                    });
                                  });
                                }
                              },
                              child: const Icon(Icons.add_location_alt,color: Colors.amber,size: 30,)),
                      ],),
                      const SizedBox(height: 8),
                      const Text(
                        'Good Morning',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),///good morning text
                      const SizedBox(height: 58),
                       Center(
                        child: SizedBox(
                          width: 300, // set the width
                          height: 240, // set the height
                          child: Image(
                            image: AssetImage(_getImagePath(_weather?.weatherConditionCode ?? 801)),
                            fit: BoxFit.cover, // scale the image to fit the container
                          ),
                        ),
                      ),///weather Image
                      const SizedBox(height: 18),
                       Center(
                        child: Text(
                          '${_weather?.temperature!.celsius!.round()}°C',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 55,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),///temp widget
                       Center(
                        child: Text(
                          '${_weather?.weatherMain!.toUpperCase()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),///weather Description
                      const SizedBox(height: 5),
                      Center(
                        child: Text(
                          DateFormat('EEEE dd •').add_jm().format(_weather!.date!),
                          //DateFormat('EEEE dd •').add_jm().format(state.weather.date!),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),///date &  time widget
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 50, // set the width
                                height: 50, // set the height
                                child: Image(
                                  image: AssetImage('assets/images/11.png'),
                                  fit: BoxFit.cover, // scale the image to fit the container
                                ),
                              ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Sunrise',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    DateFormat().add_jm().format(_weather!.sunrise!),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                            const SizedBox(
                            width: 50, // set the width
                            height: 50, // set the height
                            child: Image(
                              image: AssetImage('assets/images/12.png'),
                              fit: BoxFit.cover, // scale the image to fit the container
                            ),
                          ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Sunset',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                   // DateFormat().add_jm().format(state.weather.sunset!),
                                    DateFormat().add_jm().format(_weather!.sunset!),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),///sunrise and sunset widgets
                       const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 50, // set the width
                                height: 50, // set the height
                                child: Image(
                                  image: AssetImage('assets/images/13.png'),
                                  fit: BoxFit.cover, // scale the image to fit the container
                                ),
                              ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   const Text(
                                    'Temp Max',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                   const SizedBox(height: 3),
                                  Text(
                                    "${_weather?.tempMax!.celsius!.round()} °C",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 50, // set the width
                                height: 50, // set the height
                                child: Image(
                                  image: AssetImage('assets/images/14.png'),
                                  fit: BoxFit.cover, // scale the image to fit the container
                                ),
                              ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Temp Min',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "${_weather?.tempMin!.celsius!.round()} °C",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),///min & max Temp widgets
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

  }
  Future<String?> _showCityDialog(BuildContext context) async {
    final textController = TextEditingController();
    return showDialog<String>(context: context, builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 230,
            width: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueGrey.shade500,
                  Colors.black,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    'Enter City Name',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: textController,
                    style: const TextStyle(color: Colors.white,),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: 'City Name',
                      focusColor: Colors.teal.shade900,
                      hoverColor: Colors.teal.shade900,
                      hintText: "London , UK",
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                      border: const OutlineInputBorder(),
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel',style: TextStyle(color: Colors.black),),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(textController.text);
                        },
                        child: const Text('OK',style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  String _getImagePath(int code) {
    if (code >= 200 && code < 300) {
      return 'assets/images/1.png';
    } else if (code >= 300 && code < 400) {
      return 'assets/images/2.png';
    } else if (code >= 500 && code < 600) {
      return 'assets/images/3.png';
    } else if (code >= 600 && code < 700) {
      return 'assets/images/4.png';
    } else if (code >= 700 && code < 800) {
      return 'assets/images/5.png';
    } else if (code == 800) {
      return 'assets/images/6.png';
    } else if (code > 800 && code <= 804) {
      return 'assets/images/7.png';
    } else {
      return 'assets/images/7.png'; // default image
    }
  }
}