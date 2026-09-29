import 'dart:math';

class LocalExpression {
  static const maxSourceLength = 2000;
  static const maxDepth = 64;
  static final _blocked = RegExp(r'__import__|\bimport\b|eval\s*\(|subprocess|Process\.|open\s*\(');

  final String source;
  const LocalExpression(this.source);

  double evaluate(Map<String, double> variables) {
    if (source.length > maxSourceLength) {
      throw const FormatException('expression_too_long');
    }
    if (_blocked.hasMatch(source)) {
      throw const FormatException('expression_blocked');
    }
    final parser = _Parser(_tokenize(source), variables);
    final value = parser.expression();
    if (!parser.atEnd) throw const FormatException('Expressão incompleta ou inválida.');
    if (!value.isFinite) throw const FormatException('Resultado não finito.');
    return value;
  }
}

class _Token {
  final String kind;
  final String text;
  const _Token(this.kind, this.text);
}

List<_Token> _tokenize(String source) {
  final tokens=<_Token>[];
  var i=0;
  while (i<source.length) {
    final c=source[i];
    if (c.trim().isEmpty) { i++; continue; }
    if ('0123456789.'.contains(c)) {
      final start=i; var exponent=false;
      while (i<source.length) {
        final ch=source[i];
        if ('0123456789.'.contains(ch)) { i++; continue; }
        if ((ch=='e'||ch=='E') && !exponent) { exponent=true; i++; if (i<source.length && '+-'.contains(source[i])) i++; continue; }
        break;
      }
      tokens.add(_Token('number',source.substring(start,i))); continue;
    }
    if (RegExp(r'[A-Za-z_]').hasMatch(c)) {
      final start=i++;
      while (i < source.length && RegExp(r'[A-Za-z0-9_]').hasMatch(source[i])) {
        i++;
      }
      tokens.add(_Token('id',source.substring(start,i))); continue;
    }
    if (c=='*' && i+1<source.length && source[i+1]=='*') { tokens.add(const _Token('op','^')); i+=2; continue; }
    if ('+-*/^(),'.contains(c)) { tokens.add(_Token('op',c)); i++; continue; }
    throw FormatException('Símbolo não suportado: $c');
  }
  return tokens;
}

class _Parser {
  final List<_Token> tokens;
  final Map<String,double> variables;
  var index=0;
  var _depth=0;
  _Parser(this.tokens,this.variables);
  bool get atEnd => index==tokens.length;
  bool match(String value) {
    if (index<tokens.length && tokens[index].text==value) { index++; return true; }
    return false;
  }
  _Token take() {
    if (atEnd) throw const FormatException('Expressão incompleta.');
    return tokens[index++];
  }
  void _enter() {
    if (_depth >= LocalExpression.maxDepth) {
      throw const FormatException('expression_too_deep');
    }
    _depth++;
  }
  void _leave() {
    _depth--;
  }
  double expression() => addSub();
  double addSub() {
    var value=mulDiv();
    var extra=0;
    try {
      while (!atEnd && (tokens[index].text=='+' || tokens[index].text=='-')) {
        _enter();
        extra++;
        final op=take().text; final right=mulDiv(); value=op=='+'?value+right:value-right;
      }
      return value;
    } finally {
      for (var i=0; i<extra; i++) {
        _leave();
      }
    }
  }
  double mulDiv() {
    var value=power();
    var extra=0;
    try {
      while (!atEnd && ('*/'.contains(tokens[index].text))) {
        _enter();
        extra++;
        final op=take().text; final right=power(); value=op=='*'?value*right:value/right;
      }
      return value;
    } finally {
      for (var i=0; i<extra; i++) {
        _leave();
      }
    }
  }
  double power() {
    var value=unary();
    if (match('^')) {
      _enter();
      try {
        value=pow(value,power()).toDouble();
      } finally {
        _leave();
      }
    }
    return value;
  }
  double unary() {
    if (match('+')) {
      _enter();
      try {
        return unary();
      } finally {
        _leave();
      }
    }
    if (match('-')) {
      _enter();
      try {
        return -unary();
      } finally {
        _leave();
      }
    }
    return primary();
  }
  double primary() {
    if (match('(')) {
      _enter();
      try {
        final value=expression();
        if (!match(')')) throw const FormatException('Falta fechar parênteses.');
        return value;
      } finally {
        _leave();
      }
    }
    final token=take();
    if (token.kind=='number') return double.parse(token.text);
    if (token.kind!='id') throw const FormatException('Valor esperado.');
    if (match('(')) {
      _enter();
      try {
        final argument=expression();
        if (!match(')')) throw const FormatException('Falta fechar a função.');
        return switch(token.text) {
          'sqrt' => sqrt(argument), 'sin' => sin(argument), 'cos' => cos(argument),
          'tan' => tan(argument), 'asin' => asin(argument), 'acos' => acos(argument),
          'atan' => atan(argument), 'exp' => exp(argument), 'log' => log(argument),
          'log10' => log(argument)/ln10, 'abs' => argument.abs(),
          _ => throw FormatException('Função não suportada: ${token.text}'),
        };
      } finally {
        _leave();
      }
    }
    if (token.text=='pi') return pi;
    if (token.text=='e') return e;
    final value=variables[token.text];
    if (value==null) throw FormatException('Variável não definida: ${token.text}');
    return value;
  }
}
