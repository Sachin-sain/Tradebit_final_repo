import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/APIMainClass.dart';
import 'package:exchange/config/ToastClass.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../../config/constantClass.dart';

class LaunchPadDetail extends StatefulWidget {
  final dynamic data;
  final String status;
  const LaunchPadDetail({Key key, @required this.data, @required this.status})
      : super(key: key);

  @override
  State<LaunchPadDetail> createState() => _LaunchPadStateDetail();
}

class _LaunchPadStateDetail extends State<LaunchPadDetail> {
  Map tokenAllocation;
  Map tokenEconomics;
  Map useOfFunds;
  Map fundRaising;
  int activeRoundIndex;
  String amountToPay;
  List roundList = [];

  final TextEditingController amountController = TextEditingController();
  TextEditingController currencyController;

  void getIndex() {
    if (widget.data['launchpad_rounds'].isNotEmpty) {
      setState(() {
        roundList = widget.data['launchpad_rounds'][0]['rounds'];
        activeRoundIndex = roundList
            .indexWhere((element) => element['status'].toString() == 'true');
        if (activeRoundIndex != null && activeRoundIndex >= 0) {
          currencyController = TextEditingController(
              text: roundList[activeRoundIndex]['currency']
                  .toString()
                  .toUpperCase());
        } else {
          currencyController = TextEditingController(
              text: widget.data['launchpad_rounds'][0]['currency']
                  .toString()
                  .toUpperCase());
        }
      });
    }
  }

  Future<void> placeOrder(
      {@required String amount,
      @required String payAmount,
      @required String currency,
      @required String tokenID,
      @required String roundID}) async {
    final params = {
      "amount": amount,
      "currency": currency,
      "launch_round_id": roundID,
      "launch_token_id": tokenID,
      "pay_amount": payAmount,
    };

    print(params);
    try {
      final http.Response response = await APIMainClassbinance(
          APIClasses.launchpadOrderPlace, params, 'Post');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status_code'] == '1') {
          ToastShowClass.toastShow(context, data['message'], Colors.green);
          FocusManager.instance.primaryFocus.unfocus();
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          ToastShowClass.toastShow(context, data['message'], Colors.red);
          amountController.clear();
          amountToPay = '0';
        }
      } else {
        ToastMessage.showToast(
            context, 'Failed - ${response.reasonPhrase}', Colors.red);
        amountController.clear();
        amountToPay = '0';
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    tokenAllocation =
        Map<String, dynamic>.from(widget.data['token_allocation']);
    tokenEconomics = Map<String, dynamic>.from(widget.data['token_economics']);

    getIndex();

    useOfFunds = Map<String, dynamic>.from(widget.data['use_of_funds']);
    fundRaising = Map<String, dynamic>.from(widget.data['fund_raising']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Project Details"),
        backgroundColor: Color(0xff17394f),
      ),
      backgroundColor: day == false ? Colors.black : Colors.white,
      bottomSheet: SizedBox(
        width: width,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xff17394f))),
          onPressed: () {
            if (roundList.isEmpty) {
              ToastMessage.showToast(
                  context, 'No Rounds Available', Colors.red);
              return;
            }
            showDialog(
                context: context,
                builder: (context) => placeOrderDialog(context, height, width));
          },
          child: Text(
            'Proceed',
            style: TextStyle(
                color: day ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.01),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                children: [
                  Text(
                    widget.data['name'] == null
                        ? ''
                        : widget.data['name'].toString().toUpperCase(),
                    style: TextStyle(
                        color: day == false ? Colors.white : Colors.black,
                        fontSize: 20,
                        fontFamily: "IBM Plex Sans",
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  SizedBox(
                    width: width * 0.5,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var i = 0;
                              i < widget.data['hash_tags'].length;
                              i++)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03),
                              child: Text(
                                widget.data['hash_tags'][i] == null
                                    ? ''
                                    : '#${widget.data['hash_tags'][i]}',
                                style: TextStyle(color: Colors.grey.shade400),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      final url = Uri.parse(widget.data['token_url']);
                      if (!await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      )) {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Text(
                      widget.data['token_url'] ?? '',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          final url = Uri.parse(
                              widget.data['social_media_link']['facebook']);
                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw 'Could not launch $url';
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/image/icon/facebook.png',
                            height: 25,
                            width: 25,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      InkWell(
                        onTap: () async {
                          final url = Uri.parse(
                              widget.data['social_media_link']['twitter']);
                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw 'Could not launch $url';
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/image/icon/twitter.png',
                            height: 25,
                            width: 25,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      InkWell(
                        onTap: () async {
                          final url = Uri.parse(
                              widget.data['social_media_link']['linkedin']);
                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw 'Could not launch $url';
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/image/icon/linkedin.png',
                            height: 25,
                            width: 25,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      InkWell(
                        onTap: () async {
                          final url = Uri.parse(
                              widget.data['social_media_link']['telegram']);
                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw 'Could not launch $url';
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/image/icon/telegram.png',
                            height: 25,
                            width: 25,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CarouselSlider.builder(
                itemCount: widget.data['gallery'].length,
                options: CarouselOptions(
                  autoPlay: true,
                  // aspectRatio: 2.0,
                  enlargeCenterPage: true,
                ),
                itemBuilder: (context, index, reldx) {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 0.3),
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.network(widget.data['gallery'][index],
                            fit: BoxFit.fill,
                            width: width,
                            height: height * 0.1, loadingBuilder:
                                (BuildContext context, Widget child,
                                    ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        })),
                  );
                },
              ),
              SizedBox(height: height * 0.01),
              Divider(
                color: day ? Colors.black : Colors.white,
              ),
              SizedBox(height: height * 0.01),
              Text(
                'Project Summary ~',
                style: TextStyle(
                    color: day == false ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w600),
              ),
              Text(
                widget.data['project_summary'] ?? '',
                style: TextStyle(
                    color: day == false ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: height * 0.01),
              Divider(
                color: day ? Colors.black : Colors.white,
              ),
              SizedBox(height: height * 0.01),
              InkWell(
                onTap: () async {
                  final url = Uri.parse(widget.data['whitepaper_link']);
                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw 'Could not launch $url';
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.file_copy,
                      size: 30,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Text(
                      'WhitePaper',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.01),
              Divider(
                color: day ? Colors.black : Colors.white,
              ),
              SizedBox(height: height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Token Allocation',
                        style: TextStyle(
                            color: day == false ? Colors.white : Colors.black,
                            fontSize: 20,
                            fontFamily: "IBM Plex Sans",
                            fontWeight: FontWeight.w600),
                      ),
                      for (var i = 0;
                          i < widget.data['token_allocation'].length;
                          i++)
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.005),
                          child: Row(
                            children: [
                              Text(
                                (tokenAllocation.keys.toList()[i] == null
                                        ? ''
                                        : tokenAllocation.keys
                                            .toList()[i]
                                            .toString()
                                            .toUpperCase()) +
                                    ' : ' +
                                    (tokenAllocation.values.toList()[i] == null
                                        ? ''
                                        : tokenAllocation.values
                                            .toList()[i]
                                            .toString()
                                            .toUpperCase()),
                                style: TextStyle(
                                    color: day ? Colors.black : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: height * 0.04),
                    height: double.parse(tokenAllocation.keys
                                .toList()
                                .length
                                .toString()) >
                            double.parse(tokenEconomics.keys.length.toString())
                        ? height *
                            double.parse(tokenAllocation.keys
                                .toList()
                                .length
                                .toString()) *
                            0.035
                        : height *
                            double.parse(tokenEconomics.keys
                                .toList()
                                .length
                                .toString()) *
                            0.035,
                    width: width * 0.02,
                    child: VerticalDivider(
                      color: day ? Colors.black : Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Token Economics',
                        style: TextStyle(
                            color: day == false ? Colors.white : Colors.black,
                            fontSize: 20,
                            fontFamily: "IBM Plex Sans",
                            fontWeight: FontWeight.w600),
                      ),
                      for (var i = 0;
                          i < widget.data['token_economics'].length;
                          i++)
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.005),
                          child: Row(
                            children: [
                              Text(
                                (tokenEconomics.keys.toList()[i] == null
                                        ? ''
                                        : tokenEconomics.keys
                                            .toList()[i]
                                            .toString()
                                            .toUpperCase()) +
                                    ' : ' +
                                    (tokenEconomics.values.toList()[i] == null
                                        ? ''
                                        : tokenEconomics.values
                                            .toList()[i]
                                            .toString()
                                            .toUpperCase()),
                                style: TextStyle(
                                    color: day ? Colors.black : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                    ],
                  )
                ],
              ),
              SizedBox(height: height * 0.01),
              Divider(
                color: day ? Colors.black : Colors.white,
              ),
              SizedBox(height: height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Use Of Funds',
                        style: TextStyle(
                            color: day == false ? Colors.white : Colors.black,
                            fontSize: 20,
                            fontFamily: "IBM Plex Sans",
                            fontWeight: FontWeight.w600),
                      ),
                      for (var i = 0;
                          i < widget.data['use_of_funds'].length;
                          i++)
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.005),
                          child: Row(
                            children: [
                              Text(
                                (useOfFunds.keys.toList()[i] == null
                                        ? ''
                                        : useOfFunds.keys
                                            .toList()[i]
                                            .toString()
                                            .toUpperCase()) +
                                    ' : ' +
                                    (useOfFunds.values.toList()[i] == null
                                        ? ''
                                        : useOfFunds.values
                                            .toList()[i]
                                            .toString()
                                            .toUpperCase()),
                                style: TextStyle(
                                    color: day ? Colors.black : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: height * 0.03),
                    height: double.parse(
                                useOfFunds.keys.toList().length.toString()) >
                            double.parse(fundRaising.keys.length.toString())
                        ? height *
                            double.parse(
                                useOfFunds.keys.toList().length.toString()) *
                            0.037
                        : height *
                            double.parse(
                                fundRaising.keys.toList().length.toString()) *
                            0.037,
                    width: width * 0.02,
                    child: VerticalDivider(
                      color: day ? Colors.black : Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fund Raising',
                        style: TextStyle(
                            color: day == false ? Colors.white : Colors.black,
                            fontSize: 20,
                            fontFamily: "IBM Plex Sans",
                            fontWeight: FontWeight.w600),
                      ),
                      for (var i = 0;
                          i < widget.data['fund_raising'].length;
                          i++)
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.005),
                          child: Row(
                            children: [
                              Text(
                                (fundRaising.keys.toList()[i] == null
                                        ? ''
                                        : fundRaising.keys
                                            .toList()[i]
                                            .toString()
                                            .toUpperCase()) +
                                    ' : ' +
                                    (fundRaising.values.toList()[i] == null
                                        ? ''
                                        : fundRaising.values
                                            .toList()[i]
                                            .toString()
                                            .toUpperCase()),
                                style: TextStyle(
                                    color: day ? Colors.black : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                    ],
                  )
                ],
              ),
              SizedBox(height: height * 0.01),
              Divider(
                color: day ? Colors.black : Colors.white,
              ),
              SizedBox(height: height * 0.01),
              Text(
                'Disclaimer ~',
                style: TextStyle(
                    color: day == false ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w600),
              ),
              Text(
                widget.data['disclaimer'] ?? '',
                style: TextStyle(
                    color: day == false ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: height * 0.01),
              Divider(
                color: day ? Colors.black : Colors.white,
              ),
              SizedBox(
                height: height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }

////////  Place Order Dialog   ////////

  Widget placeOrderDialog(
    BuildContext context,
    double height,
    double width,
  ) {
    return Container(
      height: height * 0.8,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (context, setState) => Dialog(
            backgroundColor: day ? Colors.white : Colors.black,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.02),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.data['name'] == null
                            ? ''
                            : widget.data['name'].toString().toUpperCase(),
                        style: TextStyle(
                            color: day == false ? Colors.white : Colors.black,
                            fontSize: 20,
                            fontFamily: "IBM Plex Sans",
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'IEO Round',
                        style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                            fontFamily: "IBM Plex Sans",
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'IEO Price',
                        style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                            fontFamily: "IBM Plex Sans",
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  if (roundList.isNotEmpty)
                    Column(
                      children: [
                        for (var i = 0; i < roundList.length; i++)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Round ${i + 1}',
                                        style: TextStyle(
                                            color:
                                                widget.data['launchpad_rounds']
                                                                [0]['rounds'][i]
                                                            ['status'] ==
                                                        false
                                                    ? Colors.grey.shade600
                                                    : day
                                                        ? Colors.black
                                                        : Colors.white,
                                            fontSize: 15,
                                            fontFamily: "IBM Plex Sans",
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '${DateFormat("MMMM dd").format(DateTime.parse(roundList[i]['started_at']))} - ${DateFormat("MMMM dd").format(DateTime.parse(roundList[i]['expired_at']))}',
                                        style: TextStyle(
                                            color:
                                                widget.data['launchpad_rounds']
                                                                [0]['rounds'][i]
                                                            ['status'] ==
                                                        false
                                                    ? Colors.grey.shade600
                                                    : day
                                                        ? Colors.black
                                                        : Colors.white,
                                            fontSize: 12,
                                            fontFamily: "IBM Plex Sans",
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${roundList[i]['price']} ${roundList[i]['currency'].toString().toUpperCase()}',
                                    style: TextStyle(
                                        color: widget.data['launchpad_rounds']
                                                        [0]['rounds'][i]
                                                    ['status'] ==
                                                false
                                            ? Colors.grey.shade600
                                            : day
                                                ? Colors.black
                                                : Colors.white,
                                        fontSize: 15,
                                        fontFamily: "IBM Plex Sans",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                            ],
                          ),
                        // if (widget.status == "Live" && activeRoundIndex>=0)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width * 0.35,
                                  child: TextFormField(
                                    controller: amountController,
                                    enabled: widget.status == "Live" &&
                                        activeRoundIndex != null &&
                                        activeRoundIndex >= 0,
                                    onChanged: (val) {
                                      if (val.isEmpty) {
                                        return;
                                      }
                                      if (double.tryParse(widget.data[
                                                          'launchpad_rounds'][0]
                                                      ['rounds'][
                                                  activeRoundIndex]['price']) ==
                                              null ||
                                          double.tryParse(val) == null) {
                                        ToastShowClass.toastShow(context,
                                            'Enter Valid Amount', Colors.red);
                                        return;
                                      }
                                      var total = double.parse(val) *
                                          double.parse(widget
                                              .data['launchpad_rounds'][0]
                                                  ['rounds'][activeRoundIndex]
                                                  ['price']
                                              .toString());
                                      setState(() {
                                        amountToPay = total.toString();
                                      });
                                    },
                                    style: TextStyle(
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black),
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Please Enter Amount Name';
                                      }

                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black54,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                        color: day == false
                                            ? Colors.white54
                                            : Colors.black54,
                                      )),
                                      hintText: 'Amount',
                                      labelText: 'Amount',
                                      hintStyle: TextStyle(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black54),
                                      labelStyle: TextStyle(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black54),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.35,
                                  child: TextFormField(
                                    controller: currencyController,
                                    style: TextStyle(
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black),
                                    enabled: false,
                                    decoration: new InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black54,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                        color: day == false
                                            ? Colors.white54
                                            : Colors.black54,
                                      )),
                                      hintText: widget.data['launchpad_rounds']
                                          [0]['name'],
                                      labelText: 'Currency',
                                      hintStyle: TextStyle(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black54),
                                      labelStyle: TextStyle(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black54),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 0.4,
                                  child: Text(
                                    'Minimum Amount',
                                    style: TextStyle(
                                        color:
                                            day ? Colors.black : Colors.white,
                                        fontSize: 15,
                                        fontFamily: "IBM Plex Sans",
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.1),
                                    child: Divider(
                                      color: day ? Colors.black : Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width * 0.3,
                                  alignment: Alignment.bottomRight,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      widget.status == "Live" && 
                                              activeRoundIndex >= 0
                                          ? '1 ${roundList[activeRoundIndex]['symbol'].toString().toUpperCase()} '
                                          : '--',
                                      style: TextStyle(
                                          color:
                                              day ? Colors.black : Colors.white,
                                          fontSize: 15,
                                          fontFamily: "IBM Plex Sans",
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 0.4,
                                  child: Text(
                                    'Amount To Pay',
                                    style: TextStyle(
                                        color:
                                            day ? Colors.black : Colors.white,
                                        fontSize: 15,
                                        fontFamily: "IBM Plex Sans",
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.1),
                                    child: Divider(
                                      color: day ? Colors.black : Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width * 0.3,
                                  alignment: Alignment.bottomRight,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      widget.status == "Live" &&
                                              activeRoundIndex >= 0
                                          ? '${amountController.text.isEmpty ? 0 : amountToPay} ${roundList[activeRoundIndex]['currency'].toString().toUpperCase()}'
                                          : '--',
                                      style: TextStyle(
                                          color:
                                              day ? Colors.black : Colors.white,
                                          fontSize: 15,
                                          fontFamily: "IBM Plex Sans",
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            SizedBox(
                              width: width,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xff17394f))),
                                onPressed: widget.status == "Live" &&
                                        activeRoundIndex >= 0
                                    ? () {
                                        if (amountController.text.isNotEmpty &&
                                            double.tryParse(
                                                    amountController.text) !=
                                                null) {
                                          placeOrder(
                                              amount: amountController.text,
                                              payAmount: amountToPay,
                                              currency: widget
                                                  .data['launchpad_rounds'][0]
                                                      ['rounds']
                                                      [activeRoundIndex]
                                                      ['currency']
                                                  .toString()
                                                  .toUpperCase(),
                                              tokenID: widget
                                                  .data['launchpad_rounds'][0]
                                                      ['launch_token_id']
                                                  .toString(),
                                              roundID:
                                                  widget.data['launchpad_rounds']
                                                              [0]['rounds']
                                                          [activeRoundIndex]
                                                      ['t_id']);
                                        } else if (amountController
                                            .text.isEmpty) {
                                          ToastShowClass.toastShow(
                                              context,
                                              'Please Enter Amount',
                                              Colors.red);
                                          return;
                                        } else if (double.tryParse(
                                                amountController.text) ==
                                            null) {
                                          ToastShowClass.toastShow(context,
                                              'Enter Valid Amount', Colors.red);
                                        }
                                      }
                                    : null,
                                child: Text(
                                  'Place Order',
                                  style: TextStyle(
                                      color: day ? Colors.black : Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
