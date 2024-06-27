import 'package:cloud_firestore/cloud_firestore.dart';

class IMCService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<double> calculateIMC({required double height, required double weight}) async {
    return weight / (height * height);
  }

  static Map<String, dynamic> getIMCDescription(double imc) {
    String result;
    String description;
    String imagePath;

    if (imc < 18.5) {
      result = 'Abaixo do peso';
      description = '< 18,5';
      imagePath = 'assets/images/abaixo_peso.png';
    } else if (imc >= 18.5 && imc < 24.9) {
      result = 'Normal';
      description = '18,5 - 24,9';
      imagePath = 'assets/images/normal.png';
    } else if (imc >= 25.0 && imc < 29.9) {
      result = 'Sobrepeso';
      description = '25 - 29,9';
      imagePath = 'assets/images/sobrepeso.png';
    }else if (imc >= 30 && imc < 39.9) {
      result = 'Obesidade';
      description = '30 - 39,9';
      imagePath = 'assets/images/obesidade.png'; 
    }else {
      result = 'Obesidade grave';
      description = '> 40';
      imagePath = 'assets/images/obesidade_grave.png';
    }

     return {
      'result': result,
      'description': description,
      'imagePath': imagePath,
    };
  }

  Future<String> saveIMC({
    required String personUid,
    required double height,
    required double weight,
    required DateTime calcDate,
    required String imcDescription,
  }) async {
    try {
      double imcValue = await IMCService.calculateIMC(height: height, weight: weight);
      final personRef = db.collection('persons').doc(personUid);

      final imcData = {
        'height': height,
        'weight': weight,
        'calc_date': calcDate,
        'imc_value': imcValue,
        'imc_description': imcDescription,
      };

      await personRef.update({
        'imc': FieldValue.arrayUnion([imcData])
      });

      return "IMC salvo com sucesso";
    } catch (e) {
      return "Erro ao salvar IMC";
    }
  }

    Future<List<Map<String, dynamic>>> getIMCRecords(String personUid) async {
    try {
      var personRef = db.collection('persons').doc(personUid);
      var doc = await personRef.get();

      if (doc.exists) {
        var imcData = doc['imc'] as List<dynamic>;
        List<Map<String, dynamic>> imcRecords = [];

        for (var entry in imcData) {
          imcRecords.add({
            'height': entry['height'],
            'weight': entry['weight'],
            'calc_date': entry['calc_date'].toDate(),
            'imc_description': entry['imc_description'],
            'imc_value': entry['imc_value'],
          });
        }

        return imcRecords;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
