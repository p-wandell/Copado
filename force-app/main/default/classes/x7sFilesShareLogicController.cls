/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

public with sharing class x7sFilesShareLogicController {
	public static final String EXP_LEFT = '(';
	public static final String EXP_RIGHT = ')';


	public class Node {
		public Node parent { get; set; }
		public Node left { get; set; }
		public Node right { get; set ; }
		public String logicId { get; set; }
		public String operation { get; set; }
		public Set<String> data { get; set; }

		public Node() {
			logicId = '0';
			operation = '';
		}

		public Node(Node parentNode) {
			this();
			System.debug('new node');
			this.parent = parentNode;
		}

		public void dump(String msg) {
			System.debug(' node:' + msg);
			System.debug('   id: ' + logicId);
			System.debug('   op: ' + operation);
			System.debug(' leaf: ' + isLeaf());
			//System.debug(' left: ' + left);
			//System.debug('right: ' + right);
		}

		public Boolean isLeaf() {
			return left == null && right == null;
		}

		public String[] toArray() {
			final List<String> arr = new List<String>();
			preorderTraverse(this, arr);
			return arr;
		}

		private void preorderTraverse(final Node localRoot, final String[] arr) {
			if (localRoot != null) {
				processNode(arr, localRoot);
				preorderTraverse(localRoot.left, arr);
				preorderTraverse(localRoot.right, arr);
			}
		}

		private void processNode(String[] arr, Node localRoot) {
			arr.add(localRoot.logicId == '0' ? localRoot.operation : localRoot.logicId);
		}
	}

	public Node parseShareRule(String rule) {
		Node root;

		List<String> ruleParts = preParseShareRule(rule).split('');
		System.debug('ruleParts: ' + ruleParts);

		if (ruleParts.size() > 0) {
			root = new Node();

			for (String part : ruleParts) {
				switch on part {
					when '(' {
						root.left = new Node(root);
						root.right = new Node(root);
						root = root.left;
					}
					when ')' {
						if (root.parent != null) {
							root = root.parent;
						}
					}
					when 'A', 'O' {
						if (String.isNotBlank(root.operation)) {
							Node temp = new Node();
							temp.left = root;
							temp.right = new Node(temp);
							root.parent = temp;
							root = temp;
						}
						root.operation = part;
						root = root.right;
					}
					when else {
						root.logicId = part;
						root = root.parent;
					}
				}
			}
		}

		return root;
	}

	@TestVisible
	/**
	 * simplify the input for easier parsing
	 * ex. transform (1 AND (2 OR 3)) to (1A(2O3))
	*/
	private static String preParseShareRule(String inputString) {
		System.debug('inputString: ' + inputString);
		String outputString = '';
		Integer counter = 0;

		if (String.isNotBlank(inputString)) {
			inputString = inputString.replace('AND', 'A').replace('and', 'A').replace('OR', 'O').replace('or', 'O').trim();

			List<String> parts = inputString.split('');
			for (String part : parts) {
				if (String.isNotBlank(part)) {
					outputString += part;

					if (part == EXP_LEFT) {
						++counter;
					}
					if (part == EXP_RIGHT) {
						--counter;
					}
				}
			}
		}

		// check for outer brackets and add if missing
		if (counter == 0) {
			if (!outputString.startsWith(EXP_LEFT)) {
				outputString = EXP_LEFT + outputString;
			}
			if (!outputString.endsWith(EXP_RIGHT)) {
				outputString += EXP_RIGHT;
			}
		}

		System.debug('outputString: ' + (counter == 0 ? outputString : 'ERROR'));
		return counter == 0 ? outputString : '';
	}
}