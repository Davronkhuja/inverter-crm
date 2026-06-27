import 'package:flutter_test/flutter_test.dart';

import 'package:inverter_crm/core/constants/enums.dart';
import 'package:inverter_crm/data/models/inverter.dart';
import 'package:inverter_crm/state/inverter_filter.dart';

void main() {
  Inverter make({
    required String asn,
    String model = 'SUN-5K',
    String client = 'Acme',
    bool replaced = false,
    String? newAsn,
    FaultType fault = FaultType.none,
  }) {
    final now = DateTime(2024, 1, 1);
    return Inverter(
      id: asn,
      orderNo: 'ORD-$asn',
      model: model,
      asn: asn,
      clientName: client,
      faultType: fault,
      replaced: replaced,
      newAsn: newAsn,
      createdAt: now,
      updatedAt: now,
    );
  }

  group('Inverter model', () {
    test('serialize round-trip preserves fields', () {
      final inv = make(asn: 'ASN-1', replaced: true, newAsn: 'ASN-2');
      final restored = Inverter.fromMap(inv.toMap());
      expect(restored.asn, 'ASN-1');
      expect(restored.replaced, true);
      expect(restored.newAsn, 'ASN-2');
    });

    test('hasNewReplacement requires both flags', () {
      expect(
        make(asn: 'A', replaced: true, newAsn: 'B').hasNewReplacement,
        true,
      );
      expect(make(asn: 'A', replaced: true).hasNewReplacement, false);
      expect(make(asn: 'A', newAsn: 'B').hasNewReplacement, false);
    });
  });

  group('InverterFilter', () {
    final data = [
      make(
        asn: 'ASN-100',
        model: 'SUN-5K',
        client: 'Green',
        fault: FaultType.overheating,
      ),
      make(
        asn: 'ASN-200',
        model: 'SUN-8K',
        client: 'Bright',
        replaced: true,
        newAsn: 'ASN-300',
      ),
      make(asn: 'ASN-300', model: 'SUN-8K', client: 'Bright'),
    ];

    test('query matches ASN, client and model', () {
      expect(const InverterFilter(query: 'green').apply(data).length, 1);
      expect(const InverterFilter(query: 'SUN-8K').apply(data).length, 2);
      expect(const InverterFilter(query: 'asn-100').apply(data).length, 1);
    });

    test('replaced filter splits the set', () {
      expect(
        const InverterFilter(
          replaced: ReplacedFilter.replaced,
        ).apply(data).length,
        1,
      );
      expect(
        const InverterFilter(
          replaced: ReplacedFilter.notReplaced,
        ).apply(data).length,
        2,
      );
    });

    test('fault type filter narrows results', () {
      expect(
        const InverterFilter(
          faultType: FaultType.overheating,
        ).apply(data).length,
        1,
      );
    });
  });

  test('enums expose human labels', () {
    expect(OldInverterLocation.serviceCenter.label, 'Service Center');
    expect(FaultType.communication.label, 'Communication Error');
  });
}
