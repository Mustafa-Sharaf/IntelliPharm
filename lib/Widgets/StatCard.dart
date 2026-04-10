

//New code
import 'package:flutter/material.dart';
class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.033, top: size.width * 0.029),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.white,
          height: size.height * 0.14,
          width: size.width * 0.29,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Color(0xff002653),
                size: size.height * 0.045,
              ),
              SizedBox(height:size.height * 0.007),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff002653),
                  fontFamily: 'Cairo',
                ),
              ),
              // SizedBox(height: 5),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
    );
  }
}
