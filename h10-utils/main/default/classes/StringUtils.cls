public class StringUtils {
	
    /*
     * Returns either the passed in value, or if the value is null, the value of defaultValue.
     *
     * StringUtils.defaultString(null, 'NA')  = 'NA'
     * StringUtils.defaultString('', 'NA')    = ''
     * StringUtils.defaultString('bat', 'NA') = 'bat'
     */
    public static String defaultString(String value, String defaultValue) {
        return (value != null)? value: defaultValue;
    }
}