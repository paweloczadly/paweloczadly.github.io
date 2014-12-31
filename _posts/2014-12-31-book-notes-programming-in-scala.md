---
layout: post
title: "Book notes: Programming in Scala"
category: books
tags: []
comments: true
share: true
---

# Book info

- **Title**: Programming in Scala, First Edition
- **Authors**: Martin Odersky, Lex Spoon, and Bill Venners
- **Pages**: 852
- **Language**: English
- **Link**: http://www.amazon.com/Programming-Scala-Comprehensive-Step-Step/dp/0981531644

# Iterate with for and foreach

## for

- All elements:

{% highlight scala linenos %}
val lst = List(1, 2, 3, 4, 5)
for(i <- lst) {
  println(i)
}
{% endhighlight %}

- Range:

{% highlight scala linenos %}
for (i <- 0 to 2) {
  println(i)
}
{% endhighlight %}

## foreach

{% highlight scala linenos %}
val lst = List(1, 2, 3, 4, 5)
lst.foreach(i => println(i))
{% endhighlight %}

> If a function literal consists of one statement that takes a single argument, you need not explicitly name and specify the argument. Thus, the following code also works:

{% highlight scala linenos %}
lst.foreach(println)
{% endhighlight %}

# Collections

## Arrays

{% highlight scala linenos %}
val a1: Array[String] = new Array[String](3)
val a2 = new Array[String](3)
val a3: Array[String] = Array("zero", "one", "two")
val a4 = Array("zero", "one", "two")
{% endhighlight %}

## Lists

Class: `scala.collection.immutable.List`

{% highlight scala linenos %}
val l1: List[Int] = List(1, 2, 3)
val l2 = List(1, 2, 3)
{% endhighlight %}

### Concatenation

> List has a method named ':::' for list concatenation.

{% highlight scala linenos %}
val oneTwo = List(1, 2)
val threeFour = List(3, 4)
val oneTwoThreeFour = oneTwo ::: threeFour
println(""+ oneTwo +" and "+ threeFour +" were not mutated.")
println("Thus, "+ oneTwoThreeFour +" is a new list.")
{% endhighlight %}

### Adding elem to the beginning

List has a method '::' named 'cons'. It adds element to the beginning of the list.

{% highlight scala linenos %}
val twoThree = List(2, 3)
val oneTwoThree = 1 :: twoThree
println(oneTwoThree)
{% endhighlight %}

## Tuples

> Like lists, tuples are immutable, but unlike lists, tuples can contain different types of elements.

Tuples are useful when you want to return more than one object from a method. Tuples are indexed from **1**.

{% highlight scala linenos %}
val t1 = (1, "Jan")
val t2 = ('a', 'b', "and", 4, "five", 0x6)

println(t1._1) // returns 1
println(t2._5) // returns "five"
{% endhighlight %}

## Sets

Classes:

- `scala.collection.mutable.Set`
- `scala.collection.immutable.Set` - default

{% highlight scala linenos %}
val s1: Set[Int] = Set(2, 1, 3)
val s1 = Set(2, 1, 3)
{% endhighlight %}

## Maps

Classes:

- `scala.collection.mutable.Map`
- `scala.collection.immutable.Map` - default

{% highlight scala linenos %}
val romanNumeral = Map(
  1 -> "I", 2 -> "II", 3 -> "III", 4 -> "IV", 5 -> "V"
)
{% endhighlight %}
