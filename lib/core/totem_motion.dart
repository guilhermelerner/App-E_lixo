import 'package:flutter/material.dart';

/// Centraliza o respeito à preferência de movimento reduzido do sistema
/// (Acessibilidade > Remover animações), importante no totem.
class TotemMotion {
  TotemMotion._();

  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  static Duration dur(BuildContext context, int milliseconds) =>
      reduced(context) ? Duration.zero : Duration(milliseconds: milliseconds);
}
