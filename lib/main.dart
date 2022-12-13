import 'package:animated_login/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Artboard? riveArtboard;

  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  late RiveAnimationController controllerLookLift;
  late RiveAnimationController controllerLookRight;
  late RiveAnimationController controllerLookIdle;
  @override
  void initState()
  {
    super.initState();
    controllerIdle  = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp  = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown  = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerSuccess  = SimpleAnimation(AnimationEnum.success.name);
    controllerFail  = SimpleAnimation(AnimationEnum.fail.name);
    controllerLookLift  = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerLookRight  = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLookIdle  = SimpleAnimation(AnimationEnum.look_idle.name);

    rootBundle.load('assets/animated_login_character.riv').then((value) {
      final file = RiveFile.import(value);

      final artboard = file.mainArtboard;

      artboard.addController(controllerIdle);
      setState(() {
        riveArtboard = artboard;
      });

    });

    checkForPasswordFocusNode();
  }
  void removeAllControllers() {
    riveArtboard?.artboard.removeController(controllerIdle);
    riveArtboard?.artboard.removeController(controllerHandsUp);
    riveArtboard?.artboard.removeController(controllerHandsDown);
    riveArtboard?.artboard.removeController(controllerSuccess);
    riveArtboard?.artboard.removeController(controllerFail);
    riveArtboard?.artboard.removeController(controllerLookLift);
    riveArtboard?.artboard.removeController(controllerLookRight);
    riveArtboard?.artboard.removeController(controllerLookIdle);
  }

  final passwordFocusNode = FocusNode();

  bool isLookRight = false;
  bool isLookLeft = false;


  void addIdleController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerIdle);
  }

  void addHandsUpController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsUp);
  }

  void addHandsDownController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsDown);
  }

  void addSuccessController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerSuccess);
  }

  void addFailController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerFail);
  }

  void addLookLeftController() {
    removeAllControllers();
    isLookLeft = true;
    isLookRight = false;
    riveArtboard?.artboard.addController(controllerLookLift);
  }

  void addLookRightController() {
    removeAllControllers();
    isLookLeft = false;
    isLookRight = true;
    riveArtboard?.artboard.addController(controllerLookRight);
  }

  void addLookIdleController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerLookIdle);
  }

  void checkForPasswordFocusNode()
  {
    passwordFocusNode.addListener(() {
      if(passwordFocusNode.hasFocus)
        {
          addHandsUpController();
        }else if(!passwordFocusNode.hasFocus)
        {
          addHandsDownController();
        }
    });
  }
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void validateEmailAndPassword()
  {
    Future.delayed(const Duration(seconds: 1), () {
      if(formKey.currentState!.validate())
      {
        addSuccessController();
      }else{
        addFailController();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    String testEmail = 'youssifThabet@gmail.com';

    String testPassword = '123456';


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: const Center(
              child: Text(
            'Animation',
          )),
          backgroundColor: Colors.blueAccent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                      height: 200,
                      child: riveArtboard == null ? const SizedBox.shrink() : Rive(artboard: riveArtboard!)),
                  const SizedBox(height: 60,),
                  TextFormField(
                    onChanged: (value) {
                      if(value.isNotEmpty && value.length < 16 && !isLookLeft)
                        {
                          addLookLeftController();
                        }else if(value.isNotEmpty && value.length > 16 && !isLookRight)
                          {
                            addLookRightController();
                          }
                    },
                    onFieldSubmitted: (value) {
                      addLookIdleController();
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )
                    ),
                    validator: (value) => value != testEmail ? 'Wrong email' : null,
                  ),
                  const SizedBox(height: 30.0,),
                  TextFormField (
                    obscureText: true,
                    focusNode: passwordFocusNode,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        )
                    ),
                    validator: (value) => value != testPassword ? 'Wrong Password' : null,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                      ),
                      onPressed: () {
                        passwordFocusNode.hasFocus;
                        validateEmailAndPassword();
                      },
                      child: const Text('Login', style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                      ),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
