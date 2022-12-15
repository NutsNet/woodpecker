import 'dart:math';

class Node {
  Node? lt = null;
  Node? rt = null;
  Node? up = null;
  Node? dn = null;

  String? data = null;

  Node.init(int height, String? data) {
    this.data = data;

    if (height < QuadTree.height) {
      this.lt = Node.init(height + 1, "INC");
      this.rt = Node.init(height + 1, "INV");
      this.up = Node.init(height + 1, "LOAD");
      this.dn = Node.init(height + 1, "CDEC");

      QuadTree.deep = height + 1;
    }
  }
}

class QuadTree {
  static int deep = 0;
  static int height = 0;
  int nbOfBranches = 0;

  Node? root = null;

  QuadTree.init(int height) {
    QuadTree.height = height;
    for (int i = 1; i <= height; i++) {
      this.nbOfBranches += pow(4, i).toInt();
    }

    this.root = Node.init(deep, null);
  }

  List<String?> getTreeBranche(int nb) {
    List<int> lNodeIdxs = [];

    for (int i = 0; i < nb + 1; i++) {
      int j = 0;
      bool isTrue = true;

      while (isTrue) {
        if (j > lNodeIdxs.length - 1) {
          lNodeIdxs.add(0);
        }

        if (i == 0) {
          isTrue = false;
          lNodeIdxs[j] = 0;
        }

        if (isTrue) {
          lNodeIdxs[j] += 1;
          if (lNodeIdxs[j] == 4) {
            lNodeIdxs[j] = 0;
            if (j == lNodeIdxs.length - 1) {
              lNodeIdxs.add(0);
              isTrue = false;
            }
            j++;
          } else {
            isTrue = false;
          }
        }
      }
    }

    Node? cNode = root;
    List<String?> lcmds = [];

    for (int nodeIdx in lNodeIdxs) {
      switch (nodeIdx) {
        case 0:
          {
            cNode = cNode?.lt;
          }
          break;
        case 1:
          {
            cNode = cNode?.rt;
          }
          break;
        case 2:
          {
            cNode = cNode?.up;
          }
          break;
        case 3:
          {
            cNode = cNode?.dn;
          }
          break;
        default:
          {}
          break;
      }

      lcmds.add(cNode?.data);
    }

    return lcmds;
  }

  /*List<int> convertDectoFour(double nb) {
    List<int> lOfNb = [];

    print(nb);

    if (nb == 0) {
      return [0];
    }

    while (nb >= 1) {
      nb = (nb / 4);
      var rm = (nb % 4);
      nb = nb.toInt().toDouble();
      lOfNb.add(((rm - rm.truncate()) * 4).toInt());
    }

    return lOfNb;
  }*/
}
