import 'package:get/get.dart';
import 'package:demandium/components/ripple_button.dart';
import 'package:demandium/core/core_export.dart';

class SearchSuggestion extends StatelessWidget {
  const SearchSuggestion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(
      builder: (searchController){
        return Padding(
          padding:  EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('suggestions'.tr,style: ubuntuMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).colorScheme.primary),),
                  InkWell(
                    onTap: (){
                      searchController.clearSearchAddress();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: Text('clear_all'.tr,style: ubuntuMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).colorScheme.primary),),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 8 : ResponsiveHelper.isTab(context) ? 6 : 4,
                  childAspectRatio: 3/1.6,
                  crossAxisSpacing: Dimensions.PADDING_SIZE_DEFAULT,
                  mainAxisSpacing: Dimensions.PADDING_SIZE_DEFAULT,
                ),
                itemCount:searchController.historyList!.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).hoverColor,
                            borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_DEFAULT))
                          ),
                          child: Center(child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_EXTRA_SMALL,vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Text(searchController.historyList!.elementAt(index)),
                          ))),
                      Positioned.fill(child: RippleButton(onTap: () {
                        searchController.populatedSearchController(searchController.historyList!.elementAt(index));
                        searchController.searchData(searchController.historyList!.elementAt(index));
                      }))
                    ],
                  );
                },
              ),
            ],
          ),
        );
      }
    );
  }
}
