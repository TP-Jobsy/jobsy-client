part of 'projects_cubit.dart';


abstract class ProjectsState {
  const ProjectsState();
}

class ProjectsInitial extends ProjectsState {
  const ProjectsInitial();
}

class ProjectsLoading extends ProjectsState {
  const ProjectsLoading();
}

class ProjectsLoaded extends ProjectsState {
  final List<dynamic> items;
  final int currentTab;
  const ProjectsLoaded(this.items, this.currentTab);
}

class ProjectsError extends ProjectsState {
  final String message;
  const ProjectsError(this.message);
}
