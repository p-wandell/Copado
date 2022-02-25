/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

@IsTest
private class x7sFilesShareLogicControllerTest {
	@IsTest
	static void test_checkInput() {
		System.assertEquals('(1A2)', x7sFilesShareLogicController.preParseShareRule('( 1 AND 2)'));
		System.assertEquals('(1A2)', x7sFilesShareLogicController.preParseShareRule('1 AND 2'));
		System.assertEquals('((1A2)O3)', x7sFilesShareLogicController.preParseShareRule('(( 1 AND 2) OR 3)'));
		System.assertEquals('', x7sFilesShareLogicController.preParseShareRule('((1 AND 2)'));
		System.assertEquals('(((1O2)A(3O4))A5)', x7sFilesShareLogicController.preParseShareRule('(((1 OR 2 ) AND (3 OR 4)) AND 5)'));
	}

	@IsTest
	static void test_1AND2() {
		x7sFilesShareLogicController logicController = new x7sFilesShareLogicController();
		x7sFilesShareLogicController.Node root = logicController.parseShareRule('(1 AND 2)');
		System.assertNotEquals(null, root);

		System.debug(root.toArray());
		root.dump('root');
		root.left.dump('left');
		root.right.dump('right');
	}

	@IsTest
	static void test_1AND2OR3() {
		x7sFilesShareLogicController logicController = new x7sFilesShareLogicController();
		x7sFilesShareLogicController.Node root = logicController.parseShareRule('(1 AND (2 OR 3))');
		System.assertNotEquals(null, root);
		System.debug(root.toArray());

		root.dump('root');
		if (!root.isLeaf()) {
			root.left.dump('left');
			root.right.dump('right');
		}

		root = root.left;
		root.dump('going left');
		if (!root.isLeaf()) {
			root.left.dump('left');
			root.right.dump('right');
		}

		root = root.parent;
		root = root.right;
		root.dump('going right');
		if (!root.isLeaf()) {
			root.left.dump('left');
			root.right.dump('right');
		}
	}

	@IsTest
	static void test_1AND2AND3() {
		x7sFilesShareLogicController logicController = new x7sFilesShareLogicController();
		x7sFilesShareLogicController.Node root = logicController.parseShareRule('(1 AND 2 AND 3)');
		System.assertNotEquals(null, root);
		System.debug(root.toArray());

		root.dump('root');
		root.left.dump('left');
		root.right.dump('right');

		root = root.left;
		root.dump('going left');
		root.left.dump('left');
		root.right.dump('right');
	}

	@IsTest
	static void test_1OR2AND3ORAND5() {
		x7sFilesShareLogicController logicController = new x7sFilesShareLogicController();
		x7sFilesShareLogicController.Node root = logicController.parseShareRule('(((1 OR 2 ) AND (3 OR 4)) AND 5)');
		System.assertNotEquals(null, root);
		String[] rootParts = root.toArray();
		System.debug('root parts: ' + rootParts);
		System.debug('PostOrder:');
		dumpPostOrder(root);
	}

	static void dumpPostOrder(x7sFilesShareLogicController.Node node) {
		if (node != null) {
			dumpPostOrder(node.left);
			dumpPostOrder(node.right);
			node.dump('');
		}
	}
}