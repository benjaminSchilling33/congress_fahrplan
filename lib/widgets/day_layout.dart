import 'package:congress_fahrplan/model/fahrplan.dart';
import 'package:congress_fahrplan/model/room.dart';
import 'package:congress_fahrplan/widgets/fahrplan_drawer.dart';
import 'package:flutter/material.dart';

class DayLayout extends StatefulWidget {
  Fahrplan? fahrplan;
  DayLayout({this.fahrplan});

  @override
  State<DayLayout> createState() => _DayLayoutState();
}

class _DayLayoutState extends State<DayLayout> {
  List<String> rooms = Room.namesOfRooms;
  String? selectedRoom = 'All';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rooms.add('All');
  }

  @override
  Widget build(BuildContext context) {
    Widget dayTabCache = TabBarView(
      children: this.widget.fahrplan!.conference!.buildDayTabs(),
    );
    return new DefaultTabController(
      length: this.widget.fahrplan!.conference!.daysCount!,
      child: new Scaffold(
        appBar: new AppBar(
          title: Text(
            this.widget.fahrplan!.getFahrplanTitle(),
            style: TextStyle(fontFamily: 'Pilowlava'),
          ),
          /* actions: [
            rooms.length > 1
                ? DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Row(
                        children: [
                          Icon(
                            Icons.list,
                            size: 16,
                            color: Colors.yellow,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              'Select Item',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: rooms
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedRoom,
                      onChanged: (String? value) {
                        setState(() {
                          selectedRoom = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: 160,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.black26,
                          ),
                          color: Colors.redAccent,
                        ),
                        elevation: 2,
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                        ),
                        iconSize: 14,
                        iconEnabledColor: Colors.yellow,
                        iconDisabledColor: Colors.grey,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.redAccent,
                        ),
                        offset: const Offset(-20, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: MaterialStateProperty.all<double>(6),
                          thumbVisibility:
                              MaterialStateProperty.all<bool>(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  )
                : Container(),
          ], */
          bottom: PreferredSize(
            child: TabBar(
              tabs: this.widget.fahrplan!.conference!.getDaysAsText(),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                    color: Theme.of(context).indicatorColor, width: 5.0),
              ),
            ),
            preferredSize: Size.fromHeight(50),
          ),
        ),
        drawer: FahrplanDrawer(
          title: 'Overview',
        ),
        body: dayTabCache,
      ),
    );
  }
}
