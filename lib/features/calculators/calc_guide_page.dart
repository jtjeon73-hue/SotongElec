import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/electrical_calculators.dart';
import '../../core/theme/app_theme.dart';
import '../../data/calculators/calculator_guides_data.dart';
import '../../shared/widgets/common_widgets.dart';

class CalcGuidePage extends StatelessWidget {
  const CalcGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('공학용 계산기 사용법'),
          const InfoCallout(
            text:
                '특정 제조사 UI를 복제하지 않은 공통 설명입니다. '
                '시험장 허용 기종은 해당 회차 공지를 확인하세요.',
          ),
          ...CalculatorGuidesData.all.map(
            (g) => Card(
              child: ExpansionTile(
                title: Text(g.title),
                subtitle: Text(g.summary),
                childrenPadding: const EdgeInsets.all(16),
                children: [
                  ...g.steps.map((s) => Text('단계: $s')),
                  ...g.commonErrors.map((s) => Text('오류: $s')),
                  ...g.examTips.map((s) => Text('팁: $s')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorsHubPage extends StatelessWidget {
  const CalculatorsHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('전기 계산 도구'),
          Text('실제 작동 계산기 ${CalculatorCatalog.items.length}개'),
          const SizedBox(height: 8),
          ...CalculatorCatalog.items.map(
            (e) => Card(
              child: ListTile(
                leading: const Icon(
                  Icons.science_outlined,
                  color: AppColors.teal,
                ),
                title: Text(e.$2),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/calculators/${e.$1}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key, required this.id});

  final String id;

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final c1 = TextEditingController();
  final c2 = TextEditingController();
  final c3 = TextEditingController();
  final c4 = TextEditingController();
  final c5 = TextEditingController();
  String mode = 'V';
  bool threePhase = true;
  CalcResult? result;

  @override
  void dispose() {
    c1.dispose();
    c2.dispose();
    c3.dispose();
    c4.dispose();
    c5.dispose();
    super.dispose();
  }

  void _compute() {
    final id = widget.id;
    CalcResult r;
    switch (id) {
      case 'ohms':
        r = ElectricalCalculators.ohmsLaw(
          voltage: c1.text,
          current: c2.text,
          resistance: c3.text,
          solveFor: mode,
        );
      case 'power':
        r = ElectricalCalculators.power(
          voltage: c1.text,
          current: c2.text,
          resistance: c3.text,
          mode: mode,
        );
      case 'single_phase':
        r = ElectricalCalculators.singlePhasePower(
          voltage: c1.text,
          current: c2.text,
          pf: c3.text,
        );
      case 'three_phase':
        r = ElectricalCalculators.threePhasePower(
          lineVoltage: c1.text,
          lineCurrent: c2.text,
          pf: c3.text,
        );
      case 'pf':
        r = ElectricalCalculators.powerFactor(
          active: c1.text,
          apparent: c2.text,
        );
      case 'voltage_drop':
        r = ElectricalCalculators.voltageDrop(
          current: c1.text,
          resistance: c2.text,
          reactance: c3.text,
          length: c4.text,
          pf: c5.text,
          singlePhase: !threePhase,
        );
      case 'series_r':
        r = ElectricalCalculators.seriesResistance(
          c1.text.split(',').map((e) => e.trim()).toList(),
        );
      case 'parallel_r':
        r = ElectricalCalculators.parallelResistance(
          c1.text.split(',').map((e) => e.trim()).toList(),
        );
      case 'transformer_s':
        r = ElectricalCalculators.transformerCapacity(
          voltage: c1.text,
          current: c2.text,
          threePhase: threePhase,
        );
      case 'turns':
        r = ElectricalCalculators.turnsRatio(v1: c1.text, v2: c2.text);
      case 'motor_i':
        r = ElectricalCalculators.motorCurrent(
          powerKw: c1.text,
          voltage: c2.text,
          pf: c3.text,
          efficiency: c4.text,
          threePhase: threePhase,
        );
      case 'capacitor':
        r = ElectricalCalculators.capacitorKvar(
          powerKw: c1.text,
          pf1: c2.text,
          pf2: c3.text,
        );
      case 'reactance':
        r = ElectricalCalculators.reactance(
          frequency: c1.text,
          value: c2.text,
          type: mode,
        );
      case 'impedance':
        r = ElectricalCalculators.impedance(r: c1.text, x: c2.text);
      case 'resonance':
        r = ElectricalCalculators.resonance(l: c1.text, c: c2.text);
      case 'polar':
        r = mode == 'toRect'
            ? ElectricalCalculators.polarToRect(
                magnitude: c1.text,
                angleDeg: c2.text,
              )
            : ElectricalCalculators.rectToPolar(real: c1.text, imag: c2.text);
      case 'units':
        r = ElectricalCalculators.unitConvert(
          value: c1.text,
          from: c2.text.isEmpty ? 'A' : c2.text,
          to: c3.text.isEmpty ? 'mA' : c3.text,
        );
      case 'illuminance':
        r = ElectricalCalculators.illuminance(lumens: c1.text, area: c2.text);
      case 'wire':
        r = ElectricalCalculators.wireSizeReference(
          current: c1.text,
          allowable: c2.text,
        );
      case 'protection':
        r = ElectricalCalculators.protectionReference(
          loadCurrent: c1.text,
          multiplier: c2.text,
        );
      default:
        r = ElectricalCalculators.energy(powerKw: c1.text, hours: c2.text);
    }
    setState(() => result = r);
  }

  List<Widget> _fields() {
    final id = widget.id;
    Widget f(TextEditingController c, String label) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: label),
      ),
    );

    switch (id) {
      case 'ohms':
        return [
          Wrap(
            spacing: 8,
            children: ['V', 'I', 'R']
                .map(
                  (m) => ChoiceChip(
                    label: Text('$m 구하기'),
                    selected: mode == m,
                    onSelected: (_) => setState(() => mode = m),
                  ),
                )
                .toList(),
          ),
          f(c1, '전압 V'),
          f(c2, '전류 I'),
          f(c3, '저항 R'),
        ];
      case 'power':
        return [
          Wrap(
            spacing: 8,
            children: ['VI', 'I2R', 'V2R']
                .map(
                  (m) => ChoiceChip(
                    label: Text(m),
                    selected: mode == m,
                    onSelected: (_) => setState(() => mode = m),
                  ),
                )
                .toList(),
          ),
          f(c1, '전압'),
          f(c2, '전류'),
          f(c3, '저항'),
          f(c4, '시간(h) — 전력량용 참고'),
        ];
      case 'single_phase':
      case 'three_phase':
        return [f(c1, '전압'), f(c2, '전류'), f(c3, '역률')];
      case 'pf':
        return [f(c1, '유효전력 P'), f(c2, '피상전력 S')];
      case 'voltage_drop':
        return [
          SwitchListTile(
            title: const Text('삼상(√3)'),
            value: threePhase,
            onChanged: (v) => setState(() => threePhase = v),
          ),
          f(c1, '전류'),
          f(c2, 'R'),
          f(c3, 'X'),
          f(c4, '길이'),
          f(c5, '역률'),
        ];
      case 'series_r':
      case 'parallel_r':
        return [f(c1, '저항들 (쉼표 구분)')];
      case 'transformer_s':
      case 'motor_i':
        return [
          SwitchListTile(
            title: const Text('삼상'),
            value: threePhase,
            onChanged: (v) => setState(() => threePhase = v),
          ),
          if (id == 'motor_i') ...[
            f(c1, '출력 kW'),
            f(c2, '전압'),
            f(c3, '역률'),
            f(c4, '효율(0~1)'),
          ] else ...[
            f(c1, '전압'),
            f(c2, '전류'),
          ],
        ];
      case 'turns':
        return [f(c1, 'V1'), f(c2, 'V2')];
      case 'capacitor':
        return [f(c1, 'P kW'), f(c2, '개선 전 역률'), f(c3, '개선 후 역률')];
      case 'reactance':
        return [
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('XL'),
                selected: mode == 'L',
                onSelected: (_) => setState(() => mode = 'L'),
              ),
              ChoiceChip(
                label: const Text('XC'),
                selected: mode == 'C',
                onSelected: (_) => setState(() => mode = 'C'),
              ),
            ],
          ),
          f(c1, '주파수 Hz'),
          f(c2, mode == 'C' ? 'C (F)' : 'L (H)'),
        ];
      case 'impedance':
        return [f(c1, 'R'), f(c2, 'X')];
      case 'resonance':
        return [f(c1, 'L (H)'), f(c2, 'C (F)')];
      case 'polar':
        return [
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('극→직교'),
                selected: mode == 'toRect',
                onSelected: (_) => setState(() => mode = 'toRect'),
              ),
              ChoiceChip(
                label: const Text('직교→극'),
                selected: mode != 'toRect',
                onSelected: (_) => setState(() => mode = 'toPolar'),
              ),
            ],
          ),
          f(c1, mode == 'toRect' ? '크기' : '실수부'),
          f(c2, mode == 'toRect' ? '각도(°)' : '허수부'),
        ];
      case 'units':
        return [
          f(c1, '값'),
          f(c2, 'From (A,mA,V,kV,W,kW,Ω,kΩ,Hz...)'),
          f(c3, 'To'),
        ];
      case 'illuminance':
        return [f(c1, '광속 lm'), f(c2, '면적 m²')];
      case 'wire':
      case 'protection':
        return [
          const InfoCallout(
            text:
                '학습용 참고 도구입니다. 실제 설계·시공은 최신 법령, 공식 규격, '
                '제조사 자료 및 전문가 검토를 우선하세요.',
            color: AppColors.warning,
          ),
          f(c1, id == 'wire' ? '부하전류 A' : '부하전류 A'),
          f(c2, id == 'wire' ? '허용전류 A' : '배율'),
        ];
      default:
        return [f(c1, '전력 kW'), f(c2, '시간 h')];
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.id;
    for (final e in CalculatorCatalog.items) {
      if (e.$1 == widget.id) {
        title = e.$2;
        break;
      }
    }

    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionTitle(title),
          ..._fields(),
          Row(
            children: [
              FilledButton(onPressed: _compute, child: const Text('계산')),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {
                  c1.clear();
                  c2.clear();
                  c3.clear();
                  c4.clear();
                  c5.clear();
                  setState(() => result = null);
                },
                child: const Text('초기화'),
              ),
            ],
          ),
          if (result != null) ...[
            const SizedBox(height: 12),
            if (!result!.ok)
              InfoCallout(
                text: result!.error ?? '오류',
                color: AppColors.danger,
                icon: Icons.error_outline,
              )
            else ...[
              if (result!.formula.isNotEmpty) FormulaBox(result!.formula),
              Text(
                '결과: ${result!.value?.toStringAsFixed(6)} ${result!.unit}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SectionTitle('단계별 계산'),
              ...result!.steps.map((s) => Text('· $s')),
            ],
          ],
        ],
      ),
    );
  }
}
