class Cpu {
  int store = 0;
  int storePos = 0;

  List<int> addr = [];
  List<int> result = <int>[];

  Cpu.init(List<int> addr) {
    this.addr = addr;
  }

  cpuReset() {
    store = 0;
    storePos = 0;

    addr.clear();
    result.clear();
  }

  cpuIncrement() {
    storePos += 1;
    if (storePos == addr.length) {
      storePos = 0;
    }
  }

  cpuInvert() {
    if (addr[storePos] == 0) {
      addr[storePos] = 1;
    } else {
      addr[storePos] = 0;
    }
  }

  cpuLoad() {
    store = addr[storePos];
  }

  cpuCondDecrement() {
    if (store == 1) {
      if (storePos == 0) {
        storePos = addr.length - 1;
      } else {
        storePos -= 1;
      }
    }
  }

  cpuExeCmd(String cmd) {
    switch (cmd) {
      case "INC":
        {
          cpuIncrement();
        }
        break;
      case "INV":
        {
          cpuInvert();
        }
        break;
      case "LOAD":
        {
          cpuLoad();
        }
        break;
      case "CDEC":
        {
          cpuCondDecrement();
        }
        break;
      default:
        break;
    }
  }
}
