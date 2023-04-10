// ignore_for_file: must_be_immutable
import 'package:flutter_fashion/export.dart';

enum ScreenType { scroll, normal, withAppBar }

class AppBackgroundBlur extends StatelessWidget {
  final Widget child;

  final Widget? leading;

  final List<Widget>? actions;

  final List<Widget>? actionsSecond;

  final String? title;

  final Widget? bottomNavigationBar;

  final ScreenType type;

  bool? centerTitle;

  final bool isHasBackground;

  Color? backgroundAppbar;

  AppBackgroundBlur.normal({
    super.key,
    this.leading,
    this.actions,
    this.title = "",
    required this.child,
    this.type = ScreenType.normal,
    this.bottomNavigationBar,
    Widget? floatingActionButton,
    this.actionsSecond,
    this.backgroundAppbar,
    this.isHasBackground = true,
  }) : _floatingActionButon = floatingActionButton;

  Widget? _floatingActionButon;

  AppBackgroundBlur.scroll({
    super.key,
    this.leading,
    this.actions,
    this.title = "",
    this.backgroundAppbar,
    required this.child,
    this.centerTitle = true,
    this.bottomNavigationBar,
    this.type = ScreenType.scroll,
    this.actionsSecond,
    this.isHasBackground = true,
  });

  AppBackgroundBlur.withAppBar({
    super.key,
    this.leading,
    this.actions,
    this.backgroundAppbar,
    this.title = "",
    required this.child,
    this.type = ScreenType.withAppBar,
    this.bottomNavigationBar,
    Widget? floatingActionButton,
    this.actionsSecond,
    this.isHasBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (type == ScreenType.normal) {
      return _buildBody(
        child: SafeArea(
          child: SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                const SizedBox(height: 5.0),
                Expanded(child: child),
              ],
            ),
          ),
        ),
        size: size,
        context: context,
      );
    } else if (type == ScreenType.withAppBar) {
      return _buildBody(
        child: SafeArea(
          child: SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                Expanded(child: child),
              ],
            ),
          ),
        ),
        size: size,
        context: context,
      );
    }
    return _buildBody(
      child: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: horizontalPadding - 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                child,
              ],
            ),
          ),
        ),
      ),
      size: size,
      context: context,
    );
  }

  Widget _buildBody(
      {required Widget child,
      required Size size,
      required BuildContext context}) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: _floatingActionButon,
        bottomNavigationBar: bottomNavigationBar,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          fit: StackFit.passthrough,
          children: [
            isHasBackground
                ? BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, state) {
                      if (state.isDark) {
                        return const SizedBox();
                      }
                      return Positioned(
                        top: -size.height * .1,
                        left: -size.width * .65,
                        child: Image.asset(
                          "assets/images/half_circle.png",
                        ),
                      );
                    },
                  )
                : const SizedBox(),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(context) {
    if (type == ScreenType.scroll) {
      return ConstrainedBoxWidget(
        currentHeight: 0.1,
        maxHeight: 60,
        minHeight: 50,
        child: Align(
          alignment: !centerTitle! ? Alignment.centerLeft : Alignment.center,
          child: Text(
            title!,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      );
    }
    if (type == ScreenType.withAppBar) {
      return ConstrainedBoxWidget(
        currentHeight: 0.1,
        maxHeight: 55,
        minHeight: 50,
        child: ColoredBox(
          color: backgroundAppbar ??= Colors.transparent,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: horizontalPadding - 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                leading == null
                    ? const SizedBox()
                    : InkWell(
                        onTap: () => AppRoutes.router.pop(),
                        child: Icon(
                          Icons.arrow_back,
                          size: 24.0,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                title!.isEmpty ? const SizedBox() : const SizedBox(width: 10.0),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (actions != null)
                  Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: actions!.map(
                          (e) {
                            final index = actions!.indexOf(e);
                            return actions![index];
                          },
                        ).toList()),
                  )
              ],
            ),
          ),
        ),
      );
    }
    return ConstrainedBoxWidget(
      currentHeight: 0.1,
      maxHeight: 85,
      minHeight: 75,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding - 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  (leading != null)
                      ? leading!
                      : InkWell(
                          onTap: () => AppRoutes.router.pop(),
                          child: Icon(Icons.arrow_back,
                              size: 24.0,
                              color: Theme.of(context).iconTheme.color),
                        ),
                  if (actions != null)
                    for (int i = 0; i < actions!.length; i++)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          actions![i],
                        ],
                      )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (actionsSecond != null)
                  for (int i = 0; i < actionsSecond!.length; i++)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        actionsSecond![i],
                      ],
                    )
              ],
            )
          ],
        ),
      ),
    );
  }
}
