import 'dart:io';
import 'dart:isolate';

import 'cpu.dart';
import 'quadtree.dart';

String? cnb = null;
int quadTreeHeight = 12;

buildTree(List list) {
  String cnb = list[0];
  SendPort sp = list[1];
  int quadTreeHeight = 12;

  if (cnb == "2") {
    quadTreeHeight = 24;
  }

  print(Process.runSync("clear", [], runInShell: true).stdout);
  print("[ START: building quad tree");
  print("      ... ... ... ... ...  ");
  QuadTree tree = QuadTree.init(quadTreeHeight);
  Isolate.exit(sp, tree);
}

void main() async {
  setupEnv();

  if (cnb == "0") {
    testDir();
  } else {
    ReceivePort rp = ReceivePort();

    Isolate isolate;
    isolate = await Isolate.spawn(buildTree, [cnb, rp.sendPort]);

    rp.listen((data) {
      print("    END: building quad tree ]");
      QuadTree tree = data;
      isolate.kill(priority: Isolate.immediate);

      if (cnb == "1") {
        runXor(tree);
      } else if (cnb == "2") {
        run1BitAdd(tree);
      }
    });
  }
}

setupEnv() {
  do {
    print(Process.runSync("clear", [], runInShell: true).stdout);
    print(
        "Select challenge:\n\n[ 0 ] please test your directory before to test a challenge\n\n[ 1 ] test xor challenge\n[ 2 ] test 1-bit full add challenge");
    cnb = stdin.readLineSync();
  } while (cnb != "0" && cnb != "1" && cnb != "2");
}

testDir() async {
  await File("\\" + "test.txt").writeAsString("All good!");
  print("\nCheck the file test.txt has been created with \"All good!\" in it.");
}

runXor(QuadTree tree) async {
  print("\n\n[ START: solving xor challenge");

  bool isDone = false;
  for (var i = 0; i < tree.nbOfBranches; i++) {
    List<String?> lcmds = tree.getTreeBranche(i);
    List<String> cpyLcmds = List.from(lcmds);

    // 2 solutions to test
    /*cpyLcmds = [
      "INC",
      "LOAD",
      "CDEC",
      "INV",
      "LOAD",
      "CDEC",
      "LOAD",
      "CDEC",
      "INC",
      "INC",
      "INC",
      "INV"
    ];*/

    /*cpyLcmds = [
      "LOAD",
      "INC",
      "CDEC",
      "INV",
      "LOAD",
      "INC",
      "CDEC",
      "LOAD",
      "INV",
      "INC",
      "CDEC",
      "INV"
    ];*/

    Cpu cpu1 = Cpu.init([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
    Cpu cpu2 = Cpu.init([1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
    Cpu cpu3 = Cpu.init([0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
    Cpu cpu4 = Cpu.init([1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);

    cpu1.result = [0];
    cpu2.result = [1];
    cpu3.result = [1];
    cpu4.result = [0];

    for (String cmd in cpyLcmds) {
      cpu1.cpuExeCmd(cmd);
      cpu2.cpuExeCmd(cmd);
      cpu3.cpuExeCmd(cmd);
      cpu4.cpuExeCmd(cmd);

      if (cpu1.addr[2] == cpu1.result[0] &&
          cpu2.addr[2] == cpu2.result[0] &&
          cpu3.addr[2] == cpu3.result[0] &&
          cpu4.addr[2] == cpu4.result[0]) {
        isDone = true;

        print("   CMDS: $cpyLcmds");
        print("    END: xor challenge solved! ]");

        String str = "";
        for (String cmd in cpyLcmds) {
          str += cmd;
          str += "\n";
        }
        await File("\\" + "xor.wpk").writeAsString(str);

        break;
      }
    }

    if (isDone) {
      break;
    }
  }

  if (!isDone) {
    print("[ START: xor challenge unsolved");
  }

  exit(0);
}

run1BitAdd(QuadTree tree) async {
  print("\n[ START: solving 1-bit full add challenge");

  bool isDone = false;
  for (var i = 0; i < tree.nbOfBranches; i++) {
    List<String?> lcmds = tree.getTreeBranche(i);
    List<String> cpyLcmds = List.from(lcmds);

    // 1 solution to test
    /*cpyLcmds = [
      "LOAD",
      "INV",
      "CDEC",
      "CDEC",
      "INC",
      "LOAD",
      "INC",
      "CDEC",
      "CDEC",
      "CDEC",
      "CDEC",
      "INC",
      "LOAD",
      "CDEC",
      "CDEC",
      "CDEC",
      "INC",
      "INV",
      "INC",
      "INC",
      "INV",
      "INC",
      "INC",
      "INV"
    ];*/

    Cpu cpu1 = Cpu.init([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
    Cpu cpu2 = Cpu.init([1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
    Cpu cpu3 = Cpu.init([0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
    Cpu cpu4 = Cpu.init([1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);

    cpu1.result = [0, 0];
    cpu2.result = [1, 0];
    cpu3.result = [1, 0];
    cpu4.result = [0, 0];

    for (String cmd in cpyLcmds) {
      cpu1.cpuExeCmd(cmd);
      cpu2.cpuExeCmd(cmd);
      cpu3.cpuExeCmd(cmd);
      cpu4.cpuExeCmd(cmd);

      if (cpu1.addr[2] == cpu1.result[0] &&
          cpu1.addr[3] == cpu1.result[1] &&
          cpu2.addr[2] == cpu2.result[0] &&
          cpu2.addr[3] == cpu2.result[1] &&
          cpu3.addr[2] == cpu3.result[0] &&
          cpu3.addr[3] == cpu3.result[1] &&
          cpu4.addr[2] == cpu4.result[0] &&
          cpu4.addr[3] == cpu4.result[1]) {
        isDone = true;

        print("   CMDS: $cpyLcmds");
        print("    END: 1-bit full add challenge solved! ]");

        String str = "";
        for (String cmd in cpyLcmds) {
          str += cmd;
          str += "\n";
        }
        await File("\\" + "1bitadd.wpk").writeAsString(str);

        break;
      }
    }

    if (isDone) {
      break;
    }
  }

  if (!isDone) {
    print("[ START: 1-bit full add challenge unsolved");
  }

  exit(0);
}
