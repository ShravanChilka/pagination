import 'package:flutter/material.dart';

class PaginationListView<T> extends StatefulWidget {
  const PaginationListView({
    Key? key,
    required this.itemBuilder,
    required this.fetchData,
    this.errorWidget,
    this.shrinkWrap = false,
  }) : super(key: key);
  final Widget Function(
    BuildContext context,
    int index,
    List<T> data,
  ) itemBuilder;
  final Future<List<T>>? Function(int currentPage) fetchData;
  final Widget? errorWidget;
  final bool shrinkWrap;

  @override
  State<PaginationListView<T>> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T> extends State<PaginationListView<T>> {
  late final ScrollController _controller;
  late int _currentPage;
  late bool _isLoadingMore;
  List<T> data = [];

  @override
  void initState() {
    super.initState();
    _isLoadingMore = false;
    _currentPage = 1;
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      if (!_isLoadingMore) {
        setState(() => _currentPage = _currentPage + 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: widget.fetchData(_currentPage),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return widget.errorWidget ??
              Center(
                  child: Column(
                children: [
                  Text(snapshot.error.toString()),
                  TextButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  )
                ],
              ));
        } else if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.done) {
            _isLoadingMore = false;
            data.addAll(snapshot.data!);
          } else {
            _isLoadingMore = true;
          }
          return ListView.builder(
            shrinkWrap: widget.shrinkWrap,
            controller: _controller,
            itemCount: _isLoadingMore ? data.length + 1 : data.length,
            itemBuilder: (context, index) => index < data.length
                ? widget.itemBuilder(context, index, data)
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
