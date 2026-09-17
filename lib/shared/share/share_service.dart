import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/fee_grids.dart';
import '../../domain/format.dart';
import '../../domain/models/calculation_result.dart';

class ShareService {
  Future<void> shareResult({
    required CalculationResult result,
    required OperationConfig config,
    Rect? origin,
  }) {
    final wording = config.wording;
    final directLine = result.direct.possible
        ? '${wording.directBadge} : ${formatAriary(result.direct.fee ?? 0)}'
        : wording.impossible;
    final text =
        'J\'économise ${formatAriary(result.savings)} avec Kahiatra !\n\n'
        '$directLine\n'
        '${wording.splitBadge} (${result.optimized.operations.length} opérations) : '
        '${formatAriary(result.optimized.totalFee)}';

    return SharePlus.instance.share(
      ShareParams(text: text, subject: 'Économie MVola', sharePositionOrigin: origin),
    );
  }
}
