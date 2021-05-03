import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/common/common.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class StickersPage extends StatelessWidget {
  const StickersPage({
    Key? key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const StickersPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StickersBloc(),
      child: const StickersView(),
    );
  }
}

class StickersView extends StatelessWidget {
  const StickersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = context.select((PhotoboothBloc bloc) => bloc.state.image);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const PhotoboothBackground(),
          Center(
            child: AspectRatio(
              aspectRatio: isMobile ? 3 / 4 : 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (image != null) PreviewImage(data: image.data),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 24),
                      child: MadeWithIconLinks(),
                    ),
                  ),
                  const CharactersLayer(),
                  const _DraggableStickers(),
                  Positioned(
                    left: 15,
                    top: 15,
                    child: Row(
                      children: [
                        RetakeButton(
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 15),
                        const ClearStickersButtonLayer(),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 15,
                    child: OpenStickersButton(
                      onPressed: () {
                        context
                            .read<StickersBloc>()
                            .add(const StickersDrawerToggled());
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: NextButton(
                      onPressed: () =>
                          Navigator.of(context).push(SharePage.route()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocListener<StickersBloc, StickersState>(
            listenWhen: (previous, current) =>
                isMobile && current.isDrawerActive && current != previous,
            listener: (context, state) async {
              await showModalBottomSheet(
                context: context,
                barrierColor: PhotoboothColors.black.withOpacity(0.75),
                backgroundColor: PhotoboothColors.transparent,
                isScrollControlled: true,
                builder: (_) => MobileStickersDrawer(
                  onStickerSelected: (sticker) => context
                      .read<PhotoboothBloc>()
                      .add(PhotoStickerTapped(sticker: sticker)),
                ),
              );
              context.read<StickersBloc>().add(const StickersDrawerToggled());
            },
            child: const StickersDrawerLayer(),
          ),
        ],
      ),
    );
  }
}

class _DraggableStickers extends StatelessWidget {
  const _DraggableStickers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PhotoboothBloc>().state;
    if (state.stickers.isEmpty) return const SizedBox();
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: GestureDetector(
            key: const Key('stickersView_background_gestureDetector'),
            onTap: () {
              context.read<PhotoboothBloc>().add(const PhotoTapped());
            },
          ),
        ),
        for (final sticker in state.stickers)
          DraggableResizable(
            key: Key('stickerPage_${sticker.id}_draggableResizable_asset'),
            canTransform: sticker.id == state.selectedAssetId,
            onUpdate: (update) => context
                .read<PhotoboothBloc>()
                .add(PhotoStickerDragged(sticker: sticker, update: update)),
            onDelete: () => context
                .read<PhotoboothBloc>()
                .add(const PhotoDeleteSelectedStickerTapped()),
            child: Image.memory(
              sticker.asset.bytes,
              gaplessPlayback: true,
            ),
          ),
      ],
    );
  }
}

class OpenStickersButton extends StatelessWidget {
  const OpenStickersButton({Key? key, required this.onPressed})
      : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppTooltipButton(
      onPressed: onPressed,
      message: l10n.openStickersTooltip,
      mode: TooltipMode.visibleUntilInteraction,
      child: Image.asset('assets/icons/stickers_button_icon.png', height: 50),
    );
  }
}
