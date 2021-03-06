/**
 * TypeInfo support code.
 *
 * Copyright: Copyright Digital Mars 2004 - 2009.
 * License:   <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
 * Authors:   Walter Bright
 */

/*          Copyright Digital Mars 2004 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module rt.typeinfo.ti_Ag;

private import core.stdc.string;
private import rt.util.hash;
private import rt.util.string;

// byte[]

class TypeInfo_Ag : TypeInfo_Array
{
    override bool opEquals(Object o) { return TypeInfo.opEquals(o); }

    @trusted:
    const:
    pure:
    nothrow:

    override string toString() const pure nothrow @safe { return "byte[]"; }

    override size_t getHash(in void* p)
    {
        byte[] s = *cast(byte[]*)p;
        return hashOf(s.ptr, s.length * byte.sizeof);
    }

    override bool equals(in void* p1, in void* p2)
    {
        byte[] s1 = *cast(byte[]*)p1;
        byte[] s2 = *cast(byte[]*)p2;

        return s1.length == s2.length &&
               memcmp(cast(byte *)s1, cast(byte *)s2, s1.length) == 0;
    }

    override int compare(in void* p1, in void* p2)
    {
        byte[] s1 = *cast(byte[]*)p1;
        byte[] s2 = *cast(byte[]*)p2;
        size_t len = s1.length;

        if (s2.length < len)
            len = s2.length;
        for (size_t u = 0; u < len; u++)
        {
            int result = s1[u] - s2[u];
            if (result)
                return result;
        }
        if (s1.length < s2.length)
            return -1;
        else if (s1.length > s2.length)
            return 1;
        return 0;
    }

    override @property const(TypeInfo) next() nothrow pure
    {
        return typeid(byte);
    }
}


// ubyte[]

class TypeInfo_Ah : TypeInfo_Ag
{
    @trusted:
    const:
    pure:
    nothrow:

    override string toString() const pure nothrow @safe { return "ubyte[]"; }

    override int compare(in void* p1, in void* p2)
    {
        char[] s1 = *cast(char[]*)p1;
        char[] s2 = *cast(char[]*)p2;

        return dstrcmp(s1, s2);
    }

    override @property const(TypeInfo) next() nothrow pure
    {
        return typeid(ubyte);
    }
}

// void[]

class TypeInfo_Av : TypeInfo_Ah
{
    @trusted:
    const:
    pure:
    nothrow:

    override string toString() const pure nothrow @safe { return "void[]"; }

    override @property const(TypeInfo) next() nothrow pure
    {
        return typeid(void);
    }
}

// bool[]

class TypeInfo_Ab : TypeInfo_Ah
{
    @trusted:
    const:
    pure:
    nothrow:

    override string toString() const pure nothrow @safe { return "bool[]"; }

    override @property const(TypeInfo) next() nothrow pure
    {
        return typeid(bool);
    }
}

// char[]

class TypeInfo_Aa : TypeInfo_Ag
{
    @trusted:
    const:
    pure:
    nothrow:

    override string toString() const pure nothrow @safe { return "char[]"; }

    override size_t getHash(in void* p)
    {
        char[] s = *cast(char[]*)p;
        size_t hash = 0;

version (all)
{
        foreach (char c; s)
            hash = hash * 11 + c;
}
else
{
        size_t len = s.length;
        char *str = s;

        while (1)
        {
            switch (len)
            {
                case 0:
                    return hash;

                case 1:
                    hash *= 9;
                    hash += *cast(ubyte *)str;
                    return hash;

                case 2:
                    hash *= 9;
                    hash += *cast(ushort *)str;
                    return hash;

                case 3:
                    hash *= 9;
                    hash += (*cast(ushort *)str << 8) +
                            (cast(ubyte *)str)[2];
                    return hash;

                default:
                    hash *= 9;
                    hash += *cast(uint *)str;
                    str += 4;
                    len -= 4;
                    break;
            }
        }
}
        return hash;
    }

    override @property const(TypeInfo) next() nothrow pure
    {
        return typeid(char);
    }
}

// string

class TypeInfo_Aya : TypeInfo_Aa
{
    @trusted:
    const:
    pure:
    nothrow:

    override string toString() const pure nothrow @safe { return "immutable(char)[]"; }

    override @property const(TypeInfo) next() nothrow pure
    {
        return typeid(immutable(char));
    }
}

