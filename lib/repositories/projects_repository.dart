import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:in_code/config/network/network_services_api.dart';
import 'package:in_code/config/storage/sharedpref_keys.dart';
import 'package:in_code/models/category.dart';
import 'package:in_code/models/get_all_subprojects.dart';
import 'package:in_code/res/res.dart';


class ProjectsRepostiory {
  final apiServices = NetworkServicesApi();
  Future<GetAllSubProjects> getAllSubProjects({
    required String version,
    required String idUser,
    required String projectID,
  }) async {
    try {
      var uri = Uri.parse(AppUrls.getAllsubProjects);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'version': version,
          'id_user': idUser,
          'id_project': projectID,
        },
      );

      if (response.statusCode == 200) {
        print('Response data sub category: ${response.body}');
        return GetAllSubProjects.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to select project: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }


  Future<List<CategoriesModel>> getAllProjectsWithCategory() async {
    try {
      final url = Uri.parse(AppUrls.getAllCategories);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'version': '2',
          'id_user': '${box.read(userId)}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response data: $data');
        // final data1 = [
        //   {
        //     'id_category': 2,
        //     'category': 'Demo - Company 1 - London',
        //     'projects': [
        //       {
        //   'id_project': 7,
        //   'title': 'Bologna Centrale',
        //   'subtitle': 'Bologna FS - Sottoterra con Nauman',
        //   'id_company': 2
        //       },
        //       {
        //   'id_project': 5,
        //   'title': 'Magazzino pc in riparazione',
        //   'subtitle': 'Via delle industrie 123, Bologna',
        //   'id_company': 2
        //       },
        //       {
        //   'id_project': 6,
        //   'title': 'Stazione Roma Termini',
        //   'subtitle': 'Piazzale dei Cinquecento, Roma RM',
        //   'id_company': 2
        //       }
        //     ]
        //   },
        //   {
        //     'id_category': 3,
        //     'category': 'Demo - Company 2 - New York',
        //     'projects': [
        //       {
        //   'id_project': 8,
        //   'title': 'Train Station - Grand Central Terminal',
        //   'subtitle': '89 E 42nd St, New York, NY 10017, Stati Uniti',
        //   'id_company': 3
        //       }
        //     ]
        //   },
        //   {
        //     'id_category': 2,
        //     'category': 'Demo - Company 1 - London',
        //     'projects': [
        //       {
        //   'id_project': 7,
        //   'title': 'Bologna Centrale',
        //   'subtitle': 'Bologna FS - Sottoterra con Nauman',
        //   'id_company': 2
        //       },
        //       {
        //   'id_project': 5,
        //   'title': 'Magazzino pc in riparazione',
        //   'subtitle': 'Via delle industrie 123, Bologna',
        //   'id_company': 2
        //       },
        //       {
        //   'id_project': 6,
        //   'title': 'Stazione Roma Termini',
        //   'subtitle': 'Piazzale dei Cinquecento, Roma RM',
        //   'id_company': 2
        //       }
        //     ]
        //   },
        //   {
        //     'id_category': 2,
        //     'category': 'Demo - Company 1 - London',
        //     'projects': [
        //       {
        //   'id_project': 7,
        //   'title': 'Bologna Centrale',
        //   'subtitle': 'Bologna FS - Sottoterra con Nauman',
        //   'id_company': 2
        //       },
        //       {
        //   'id_project': 5,
        //   'title': 'Magazzino pc in riparazione',
        //   'subtitle': 'Via delle industrie 123, Bologna',
        //   'id_company': 2
        //       },
        //       {
        //   'id_project': 6,
        //   'title': 'Stazione Roma Termini',
        //   'subtitle': 'Piazzale dei Cinquecento, Roma RM',
        //   'id_company': 2
        //       }
        //     ]
        //   },
        //   {
        //     'id_category': 2,
        //     'category': 'Demo - Company 1 - London',
        //     'projects': [
        //       {
        //   'id_project': 7,
        //   'title': 'Bologna Centrale',
        //   'subtitle': 'Bologna FS - Sottoterra con Nauman',
        //   'id_company': 2
        //       },
        //       {
        //   'id_project': 5,
        //   'title': 'Magazzino pc in riparazione',
        //   'subtitle': 'Via delle industrie 123, Bologna',
        //   'id_company': 2
        //       },
        //       {
        //   'id_project': 6,
        //   'title': 'Stazione Roma Termini',
        //   'subtitle': 'Piazzale dei Cinquecento, Roma RM',
        //   'id_company': 2
        //       }
        //     ]
        //   },
        //   {
        //     'id_category': 2,
        //     'category': 'Demo - Company 1 - London',
        //     'projects': [
        //       {
        //   'id_project': 7,
        //   'title': 'Bologna Centrale',
        //   'subtitle': 'Bologna FS - Sottoterra con Nauman',
        //   'id_company': 2
        //       },
        //       {
        //   'id_project': 5,
        //   'title': 'Magazzino pc in riparazione',
        //   'subtitle': 'Via delle industrie 123, Bologna',
        //   'id_company': 2
        //       },
        //       {
        //   'id_project': 6,
        //   'title': 'Stazione Roma Termini',
        //   'subtitle': 'Piazzale dei Cinquecento, Roma RM',
        //   'id_company': 2
        //       }
        //     ]
        //   },
        //   {
        //     'id_category': 2,
        //     'category': 'Demo - Company 1 - London',
        //     'projects': [
        //       {
        //   'id_project': 7,
        //   'title': 'Bologna Centrale',
        //   'subtitle': 'Bologna FS - Sottoterra con Nauman',
        //   'id_company': 2
        //       },
        //       {
        //   'id_project': 5,
        //   'title': 'Magazzino pc in riparazione',
        //   'subtitle': 'Via delle industrie 123, Bologna',
        //   'id_company': 2
        //       },
        //       {
        //   'id_project': 6,
        //   'title': 'Stazione Roma Termini',
        //   'subtitle': 'Piazzale dei Cinquecento, Roma RM',
        //   'id_company': 2
        //       }
        //     ]
        //   },
        //   {
        //     'id_category': 2,
        //     'category': 'Demo - Company 1 - London',
        //     'projects': [
        //       {
        //   'id_project': 7,
        //   'title': 'Bologna Centrale',
        //   'subtitle': 'Bologna FS - Sottoterra con Nauman',
        //   'id_company': 2
        //       },
        //       {
        //   'id_project': 5,
        //   'title': 'Magazzino pc in riparazione',
        //   'subtitle': 'Via delle industrie 123, Bologna',
        //   'id_company': 2
        //       },
        //       {
        //   'id_project': 6,
        //   'title': 'Stazione Roma Termini',
        //   'subtitle': 'Piazzale dei Cinquecento, Roma RM',
        //   'id_company': 2
        //       }
        //     ]
        //   },
        //   {
        //     'id_category': 2,
        //     'category': 'Demo - Company 1 - London',
        //     'projects': [
        //       {
        //   'id_project': 7,
        //   'title': 'Bologna Centrale',
        //   'subtitle': 'Bologna FS - Sottoterra con Nauman',
        //   'id_company': 2
        //       },
        //       {
        //   'id_project': 5,
        //   'title': 'Magazzino pc in riparazione',
        //   'subtitle': 'Via delle industrie 123, Bologna',
        //   'id_company': 2
        //       },
        //       {
        //   'id_project': 6,
        //   'title': 'Stazione Roma Termini',
        //   'subtitle': 'Piazzale dei Cinquecento, Roma RM',
        //   'id_company': 2
        //       }
        //     ]
        //   },
      
        // ];
       
        // print('Response data1: $data1');
        final categories = (data as List)
            .map((item) => CategoriesModel.fromJson(item))
            .toList();
             print('Fetched categories: $categories');
        return categories;
       
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      throw Exception();
    }
  }
}
