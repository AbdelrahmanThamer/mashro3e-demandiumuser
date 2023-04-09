import 'package:demandium/components/footer_base_view.dart';
import 'package:demandium/components/menu_drawer.dart';
import 'package:demandium/core/core_export.dart';

class SubCategoryScreen extends StatelessWidget {
  final String categoryTitle;
  const SubCategoryScreen({Key? key, required this.categoryTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer:ResponsiveHelper.isDesktop(context) ? MenuDrawer():null,
        appBar: CustomAppBar(title: categoryTitle,),
      body: FooterBaseView(
        child: SizedBox(
          width: Dimensions.WEB_MAX_WIDTH,
          child: CustomScrollView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height:
                ResponsiveHelper.isDesktop(context)?Dimensions.PADDING_SIZE_EXTRA_LARGE:0,
                ),
              ),
              SubCategoryView(isScrollable: true,),
            ],
          ),
        ),
      )
    );
  }
}
