import 'package:flutter/material.dart';

class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.2,
          width: size.width * 0.96,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(color: const Color(0xff016E65)),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.15,
                        child: Image.asset(
                          'assets/images/DrawerHeaderImage.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(size.width * 0.03),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Image.asset('assets/icons/location.png'),
                          ),
                          const Spacer(),
                          Text(
                            "Plan Today's\nRoute",
                            style: TextStyle(
                              fontSize: size.width * 0.055,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Cairo',
                            ),
                          ),

                          Text(
                            "12 destinations optimized",
                            style: TextStyle(
                              fontSize: size.width * 0.033,
                              color: Colors.white.withValues(alpha: 0.5),
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.white,
                  height: 120,
                  width: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*  Container(
                        color: Colors.grey,
                        child: Image.asset(
                          'assets/icons/visits.png',
                          width: 40,
                          height: 40,
                        ),
                      ),*/
                      //SizedBox(height: 5),
                      Icon(
                        Icons.verified_rounded,
                        color: Color(0xff002653),
                        size: 30,
                      ),
                      SizedBox(height: 7),
                      Text(
                        "33",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff002653),
                          fontFamily: 'Cairo',
                        ),
                      ),
                     // SizedBox(height: 5),
                      Text(
                        "Visits",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff43474F),
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.white,
                  height: 120,
                  width: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*  Container(
                        color: Colors.grey,
                        child: Image.asset(
                          'assets/icons/visits.png',
                          width: 40,
                          height: 40,
                        ),
                      ),*/
                      //SizedBox(height: 5),
                      Icon(Icons.handshake_rounded, color: Color(0xff002653), size: 30,),
                      SizedBox(height: 7),
                      Text(
                        "9",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff002653),
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Deals",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff43474F),
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.white,
                  height: 120,
                  width: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*  Container(
                        color: Colors.grey,
                        child: Image.asset(
                          'assets/icons/visits.png',
                          width: 40,
                          height: 40,
                        ),
                      ),*/
                      //SizedBox(height: 5),
                      Icon(Icons.inventory_2_rounded, color: Color(0xff002653), size: 30,),
                      SizedBox(height: 7),
                      Text(
                        "13",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff002653),
                          fontFamily: 'Cairo',
                        ),
                      ),
                      //SizedBox(height: 5),
                      Text(
                        "Orders",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff43474F),
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
