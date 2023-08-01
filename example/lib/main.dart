import 'dart:math';

import 'package:dx_table/dx_table.dart';
import 'package:example/data/table_data.dart';
import 'package:flutter/material.dart';

import 'data/player_data_model.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final DxTableController dxTableController = DxTableController();
  late List<PlayerDataModel> players;

  @override
  void initState() {
    players = TableData.players;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: DxTable(
            tableWidth: size.width,
            height: size.height,
            animationDuration: const Duration(microseconds: 0),
            header: DxTableHeader(
              titleAlignment: Alignment.centerLeft,
              backgroundColor: Colors.deepPurple,
              titles:
                  TableData.headerTitles.map((e) => _headerElement(e)).toList(),
            ),
            rows: TableData.players.map((e) => dxTableRow(e)).toList(),
            dxTableController: dxTableController,
            onClick: (index) {
              dxTableController.select(index, refreshState: true);
              print(index);
            },
          ),
        ),
      ),
    );
  }

  DxHeaderElement _headerElement(String title) {
    return DxHeaderElement(
      align: Alignment.centerLeft,

      sortingMechanism: DxTableSortMechanism<String>(
        comparator: (a, b) => a.compareTo(b) < 0,
      ),
      // backgroundColor:
      //     Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
      builder: (context, sortState, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 5),
            _sortStateBasedArrow(sortState, index)
          ],
        );
      },
    );
  }

  Widget _sortStateBasedArrow(DxTableSortState sortState, int index) {
    switch (sortState) {
      case DxTableSortState.unsorted:
        return InkWell(
          onTap: () => dxTableController.sort(index),
          child: const SizedBox(
            height: 10,
            width: 10,
            child: RotatedBox(
              quarterTurns: 3,
              child: Icon(
                Icons.arrow_back_ios,
                size: 10,
                color: Colors.grey,
              ),
            ),
          ),
        );
      case DxTableSortState.sorted:
        return InkWell(
          onTap: () => dxTableController.sort(index),
          child: const SizedBox(
            height: 10,
            width: 10,
            child: RotatedBox(
              quarterTurns: 3,
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 10,
              ),
            ),
          ),
        );
      case DxTableSortState.reversed:
        return InkWell(
          onTap: () => dxTableController.clearSort(),
          child: const SizedBox(
            height: 10,
            width: 10,
            child: RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 10,
              ),
            ),
          ),
        );
    }
  }

  DxTableRow dxTableRow(PlayerDataModel playerDataModel) {
    return DxTableRow(
      backgroundColor: Colors.white,
      hoverColor: Colors.grey,
      selectedColor: Colors.grey,
      enableSelection: true,
      children: [
        _rowElement(playerDataModel.id.toString()),
        _rowElement(playerDataModel.name),
        _rowElement(playerDataModel.age.toString()),
        _rowElement(playerDataModel.nationality.toString()),
        _rowElement(playerDataModel.club.toString()),
        _rowElement(playerDataModel.position.toString()),
        _rowElement(playerDataModel.goalsScored.toString()),
        _rowElement(playerDataModel.assists.toString()),
      ],
    );
  }

  DxTableRowElement<dynamic> _rowElement(String value) {
    return DxTableRowElement<String>(
      sortElement: value,
      builder: (context, isSelected, isHovered, hoverValue, rowIndex) {
        return Text(
          value,
          style: TextStyle(
            color: isHovered ? Colors.white : Colors.black,
          ),
        );
      },
    );
  }
}
