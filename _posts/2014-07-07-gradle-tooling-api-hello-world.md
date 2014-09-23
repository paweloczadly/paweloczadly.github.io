---
layout: post
title: "Gradle tooling API: hello world"
category: dev
tags: [gradle, groovy, spock]
---
{% include JB/setup %}

## What is tooling API?

Gradle tooling API allows you to interact with Gradle directly. You can use it to run your tasks, to test output and other results.

## Basic example

In this article I would like to present the simplest example of usage Gradle tooling API - displaying available tasks. Let's assume we have the following build file:

{% highlight gradle %}
apply plugin: 'groovy'
apply plugin: 'idea'

repositories {
    mavenCentral()
    maven { url 'http://repo.gradle.org/gradle/libs-releases-local' }
}

dependencies {
    testCompile 'org.spockframework:spock-core:0.7-groovy-2.0'
    testCompile 'org.gradle:gradle-tooling-api:2.0-rc-1'
}
{% endhighlight %}

To display available tasks and to check if everything works fine, I created unit test with the help of [Spock](http://spock-framework.readthedocs.org/en/latest/) in **src/test/groovy** directory:

{% highlight groovy %}
import org.gradle.tooling.GradleConnector
import spock.lang.Specification

class SimpleTest extends Specification{

    def path = new File('C:/Users/pawel.oczadly/gradle-tooling-api-hello-world')

    def 'should display all tasks'() {
        given:
        def conn = GradleConnector.newConnector().forProjectDirectory(path).connect()

        when:
        conn.newBuild().forTasks('tasks').run()

        then:
        conn.close()
    }
}
{% endhighlight %}

After running **gradle test** Gradle displayed all available tasks:

        08:32:18.858 [Connection worker] DEBUG o.g.t.i.provider.DefaultConnection - Tooling API provider 2.0-rc-1 created.
        08:32:19.106 [Connection worker] DEBUG o.g.t.i.provider.ProviderConnection - Configuring logging to level: INFO
        Tooling API is using target Gradle version: 2.0-rc-1.
        Starting Gradle daemon
        Starting daemon process: workingDir = C:\Users\pawel.oczadly\.gradle\daemon\2.0-rc-1, daemonArgs: [C:\Program Files\Java\jdk1.8.0_05\bin\java.exe, -XX:MaxPermSize=256m, -XX:+HeapDumpOnOutOfMemoryError, -Xmx1024m, -Dfile.encoding=windows-1250, -cp, C:\Users\pawel.oczadly\.gradle\wrapper\dists\gradle-2.0-rc-1-bin\4rau6kski4dn6gj70iqn8pqs3c\gradle-2.0-rc-1\lib\gradle-launcher-2.0-rc-1.jar, org.gradle.launcher.daemon.bootstrap.GradleDaemon, 2.0-rc-1, C:\Users\pawel.oczadly\.gradle\daemon, 10800000, 7793f289-f768-4f88-91a8-770a9f58c56b, -XX:MaxPermSize=256m, -XX:+HeapDumpOnOutOfMemoryError, -Xmx1024m, -Dfile.encoding=windows-1250]
        Starting process 'Gradle build daemon'. Working directory: C:\Users\pawel.oczadly\.gradle\daemon\2.0-rc-1 Command: C:\Program Files\Java\jdk1.8.0_05\bin\java.exe -XX:MaxPermSize=256m -XX:+HeapDumpOnOutOfMemoryError -Xmx1024m -Dfile.encoding=windows-1250 -cp C:\Users\pawel.oczadly\.gradle\wrapper\dists\gradle-2.0-rc-1-bin\4rau6kski4dn6gj70iqn8pqs3c\gradle-2.0-rc-1\lib\gradle-launcher-2.0-rc-1.jar org.gradle.launcher.daemon.bootstrap.GradleDaemon 2.0-rc-1 C:\Users\pawel.oczadly\.gradle\daemon 10800000 7793f289-f768-4f88-91a8-770a9f58c56b -XX:MaxPermSize=256m -XX:+HeapDumpOnOutOfMemoryError -Xmx1024m -Dfile.encoding=windows-1250
        Successfully started process 'Gradle build daemon'
        An attempt to start the daemon took 1.792 secs.
        Connected to the daemon. Dispatching Build{id=e2257a8d-ac83-45b5-a53b-1a12fc6adf29.1, currentDir=C:\Users\pawel.oczadly\gradle-tooling-api-hello-world} request.
        :tasks

        ------------------------------------------------------------
        All tasks runnable from root project
        ------------------------------------------------------------

        Build tasks
        -----------
        assemble - Assembles the outputs of this project.
        build - Assembles and tests this project.
        buildDependents - Assembles and tests this project and all projects that depend on it.
        buildNeeded - Assembles and tests this project and all projects it depends on.
        classes - Assembles classes 'main'.
        clean - Deletes the build directory.
        jar - Assembles a jar archive containing the main classes.
        testClasses - Assembles classes 'test'.

        Build Setup tasks
        -----------------
        init - Initializes a new Gradle build. [incubating]
        wrapper - Generates Gradle wrapper files. [incubating]

        Documentation tasks
        -------------------
        groovydoc - Generates Groovydoc API documentation for the main source code.
        javadoc - Generates Javadoc API documentation for the main source code.

        Help tasks
        ----------
        dependencies - Displays all dependencies declared in root project 'gradle-tooling-api-hello-world'.
        dependencyInsight - Displays the insight into a specific dependency in root project 'gradle-tooling-api-hello-world'.
        help - Displays a help message
        projects - Displays the sub-projects of root project 'gradle-tooling-api-hello-world'.
        properties - Displays the properties of root project 'gradle-tooling-api-hello-world'.
        tasks - Displays the tasks runnable from root project 'gradle-tooling-api-hello-world'.

        IDE tasks
        ---------
        cleanIdea - Cleans IDEA project files (IML, IPR)
        idea - Generates IDEA project files (IML, IPR, IWS)

        Verification tasks
        ------------------
        check - Runs all checks.
        test - Runs the unit tests.

        Other tasks
        -----------
        cleanIdeaWorkspace

        Rules
        -----
        Pattern: clean<TaskName>: Cleans the output files of a task.
        Pattern: build<ConfigurationName>: Assembles the artifacts of a configuration.
        Pattern: upload<ConfigurationName>: Assembles and uploads the artifacts belonging to a configuration.

        To see all tasks and more detail, run with --all.

        BUILD SUCCESSFUL

        Total time: 6.679 secs
