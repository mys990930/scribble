import 'package:flutter/material.dart';
import 'package:scribble/domain/models/routine.dart';

bool _is10MinAligned(DateTime t) => t.minute % 10 == 0 && t.second == 0 && t.millisecond == 0;

void validateRoutine(Routine r) {
  if (!_is10MinAligned(r.startTime) || !_is10MinAligned(r.endTime)) {
    throw ArgumentError('Routine times must be aligned to 10-minute marks.');
  }
  if (!r.endTime.isAfter(r.startTime)) {
    throw ArgumentError('endTime must be after startTime.');
  }
}

void validateNoOverlap(List<Routine> routines) {
  final sorted = [...routines]..sort((a,b)=>a.startTime.compareTo(b.startTime));
  for (int i=1;i<sorted.length;i++) {
    if (sorted[i].startTime.isBefore(sorted[i-1].endTime)) {
      throw ArgumentError('Routines may not overlap: ${sorted[i-1].name} / ${sorted[i].name}');
    }
  }
}