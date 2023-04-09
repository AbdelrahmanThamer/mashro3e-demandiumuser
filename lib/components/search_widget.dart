import 'package:get/get.dart';
import 'package:demandium/core/core_export.dart';

class SearchWidget extends StatelessWidget {
   SearchWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(
      builder: (searchController){
        return Center(child: Padding(
            padding: const EdgeInsets.only(
                top:5.0,
                left: Dimensions.PADDING_SIZE_DEFAULT,
                right: Dimensions.PADDING_SIZE_DEFAULT),
            child: Container(
                height: Dimensions.SEARCH_BER_SIZE,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.horizontal(right: Radius.circular(25,),left: Radius.circular(25)),
                  boxShadow:Get.isDarkMode? null: searchBoxShadow,
                ),
                child: TextField(
                  controller: searchController.searchController,
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Theme.of(context).textTheme.bodyText1!.color, fontSize: Dimensions.fontSizeLarge,
                  ),
                  cursorColor: Theme.of(context).hintColor,
                  autofocus: false,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(25,),left: Radius.circular(25)),
                      borderSide: BorderSide(style: BorderStyle.none, width: 0),
                    ),
                    fillColor: Get.isDarkMode? Theme.of(context).primaryColorDark:Color(0xffFEFEFE),
                    isDense: true,
                    hintText: 'search_services'.tr,
                    hintStyle: Theme.of(context).textTheme.headline2!.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).hintColor),
                    filled: true,
                    prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
                    suffixIcon: searchController.isActiveSuffixIcon ? IconButton(
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        if(searchController.searchController.text.trim().isNotEmpty) {
                          searchController.clearSearchController();
                        }
                        FocusScope.of(context).unfocus();
                      },
                      icon: Icon(Icons.cancel_outlined),
                    ) : SizedBox(),
                  ),
                  onChanged: (text) => searchController.showSuffixIcon(context,text),
                  onSubmitted: (text) {
                    if(text.isNotEmpty) {
                      searchController.searchData(text);
                    }
                  },
                )
            )));
      },
    );
  }
}
