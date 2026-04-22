import 'package:flutter/material.dart';
import 'package:sun_gate_app/app/constants/app_assets.dart';
import 'package:sun_gate_app/core/utils/app_string.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Center(
            child: Image.asset(
              AppAssets.splashLogo,
              width: 150,
              height: 150,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) {
                return const SizedBox(
                  width: 90,
                  height: 90,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 40,
                      color: Colors.white70,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppStrings.get(context, 'sun_gate'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),

            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
