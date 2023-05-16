import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DataService {
  final ValueNotifier<List> tableStateNotifier = new ValueNotifier([]);

  var keys = ["name", "style", "ibu"];
  var columns = ["MUDANÇA", "DE", "ESTADO"];

  void carregar(index) {
    var funcoes = [
      carregarFilmes,
      carregarSeries,
      carregarLivros,
    ];

    funcoes[index]();
  }

  void columnMovies() {
    keys = ["Movie", "director", "duration"];
    columns = ["Filme", "Diretor", "Duração"];
  }

  void columnBooks() {
    keys = ["books", "gender", "criation"];
    columns = ["Livros", "Gênero", "criação"];
  }

  void columnShows() {
    keys = ["shows", "season", "episodes"];
    columns = ["Séries", "Temporadas", "episódios"];
  }

  void carregarFilmes() {
    columnMovies();

    tableStateNotifier.value = [
      {
        "Movie": "Táxi Driver",
        "director": "Martin Scorcese",
        "duration": "1h54m"
      },
      {
        "Movie": "Mad Max: fury road",
        "director": "George Miller",
        "duration": "2h"
      },
      {
        "Movie": "A lista de Schindler",
        "director": "Steven Spielberg",
        "duration": "17"
      },
      {
        "Movie": "Blade Runner 2049",
        "director": "Dennis Villanueve",
        "duration": "2h43m"
      },
      {
        "Movie": "Jogador número 1",
        "director": "Steven Spielberg",
        "duration": "2h20m"
      }
    ];
  }

  void carregarSeries() {
    columnBooks();

    tableStateNotifier.value = [
      {"books": "Duna", "gender": "Ficção científica", "criation": "1968"},
      {"books": "Watchmen", "gender": "Super-herói", "criation": "1986"},
      {"books": "Sandman", "gender": "Fantasia/terror", "criation": "1989"},
      {
        "books": "Matadouro cinco",
        "gender": "Romance/ficção cientifica",
        "criation": "1969"
      },
      {"books": "Maus", "gender": "Romance/biografia", "criation": "1980"}
    ];
  }

  void carregarLivros() {
    columnShows();

    tableStateNotifier.value = [
      {
        "shows": "Avatar: lenda de Aang",
        "season": "3 temporadas",
        "episodes": "61 episodios"
      },
      {
        "shows": "Yellowstone",
        "season": "5 temporadas",
        "episodes": "47 episódios"
      },
      {
        "shows": "Demolidor",
        "season": "3 temporadas",
        "episodes": "39 episódios"
      },
      {"shows": "Reacher", "season": "1 temporada", "episodes": "8 episodios"},
      {
        "shows": "Pacificador",
        "season": "1 temporada",
        "episodes": "8 episodios"
      }
    ];
  }
}

final dataService = DataService();

void main() {
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.lightBlue),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Recomendações de bons conteúdos"),
          ),
          body: ValueListenableBuilder(
              valueListenable: dataService.tableStateNotifier,
              builder: (_, value, __) {
                return DataTableWidget(
                  jsonObjects: value,
                  propertyNames: dataService.keys,
                  columnNames: dataService.columns,
                );
              }),
          bottomNavigationBar:
              NewNavBar(itemSelectedCallback: dataService.carregar),
        ));
  }
}

class NewNavBar extends HookWidget {
  var itemSelectedCallback;

  NewNavBar({this.itemSelectedCallback}) {
    itemSelectedCallback ??= (_) {};
  }

  @override
  Widget build(BuildContext context) {
    var state = useState(1);
    return BottomNavigationBar(
        onTap: (index) {
          state.value = index;
          itemSelectedCallback(index);
        },
        currentIndex: state.value,
        items: const [
          BottomNavigationBarItem(
            label: "Filmes",
            icon: Icon(Icons.movie),
          ),
          BottomNavigationBarItem(label: "Livros", icon: Icon(Icons.book)),
          BottomNavigationBarItem(label: "Séries", icon: Icon(Icons.tv))
        ]);
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;

  DataTableWidget(
      {this.jsonObjects = const [],
      this.columnNames = const ["Nome", "Estilo", "IBU"],
      this.propertyNames = const ["name", "style", "ibu"]});
  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: columnNames
            .map((name) => DataColumn(
                label: Expanded(
                    child: Text(name,
                        style: TextStyle(fontStyle: FontStyle.italic)))))
            .toList(),
        rows: jsonObjects
            .map((obj) => DataRow(
                cells: propertyNames
                    .map((propName) => DataCell(Text(obj[propName])))
                    .toList()))
            .toList());
  }
}
