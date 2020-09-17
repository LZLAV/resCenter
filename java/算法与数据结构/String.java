String


示例代码
		String s1 = new String();
		String s2 = "billryan";
		int s2Len = s2.length();
		s2.substring(4, 8); // return "ryan"
		StringBuilder s3 = new StringBuilder(s2.substring(4, 8));
		s3.append("bill");
		String s2New = s3.toString(); // return "ryanbill"
		// convert String to char array
		char[] s2Char = s2.toCharArray();
		// char at index 4
		char ch = s2.charAt(4); // return 'r'
		// find index at first
		int index = s2.indexOf('r'); // return 4. if not found, return -1
		
		
StringBuffer 与 StringBuilder, 前者保证线程安全，后者不是，但单线程下效率高一些，一般使用 StringBuilder.