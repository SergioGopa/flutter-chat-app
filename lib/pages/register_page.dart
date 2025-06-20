import 'package:chat/helpers/show_alert.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LogoWidget(
                  title: 'Register',
                ),
                _Form(),
                LabelsWidget(
                  route: 'login',
                  title: 'Ya tienes cuenta?',
                  subtitle: 'Ingresa aqui',
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Text(
                      'Terminos y condiciones de uso',
                      style: TextStyle(
                          fontWeight: FontWeight.w200, color: Colors.black),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Name',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Password',
            // keyboardType: TextInputType.emailAddress,
            textController: passCtrl,
            isPassword: true,
          ),
          BlueBtnWidget(
            placeholder:authService.authenticating?'Authenticating':'Create account',
            onpressed: authService.authenticating
                ? null
                : () async {
                    final registerOk = await authService.register(
                        nameCtrl.text.trim(), emailCtrl.text.trim(), passCtrl.text.trim());
                    
                    FocusScope.of(context).unfocus();

                    if (registerOk == true) {
                      Navigator.pushReplacementNamed(context, 'login');
                    } else {
                      showAlert(context, 'Registro Incorrecto',
                          registerOk);
                    }
                    print(nameCtrl.text);
                    print(passCtrl.text);
                    print(emailCtrl.text);
                  },
          )
        ],
      ),
    );
  }
}
