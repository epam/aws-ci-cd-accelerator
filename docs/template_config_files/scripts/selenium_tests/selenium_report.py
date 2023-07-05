from junitparser import JUnitXml
import argparse
import sys

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    # parser.add_argument('--selenium-server-url', type=str, required=False)
    # parser.add_argument('--app-target-url', type=str, required=False)
    parser.add_argument('--report', type=str, default="./report.xml")
    parser.add_argument('--pass-rate', type=int, default=100)
    args = parser.parse_args()
    # print(args)

    xml = JUnitXml.fromfile(args.report)

    success_rate = int(100 - (xml.failures + xml.errors) * 100 / xml.tests if xml.tests > 0 else 100)
    print(f'Success rate {success_rate}% (total={xml.tests}, errors={xml.errors}, failures={xml.failures})')
    print('Success rate >>>', success_rate)
    print('Pass rate >>>', args.pass_rate)
    print(success_rate < args.pass_rate)
    if success_rate < args.pass_rate:
        print(f'Failing build ({success_rate} < {args.pass_rate})')
        sys.exit(1)

    sys.exit(0)