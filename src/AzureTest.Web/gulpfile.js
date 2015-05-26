var gulp = require('gulp');
var less = require('gulp-less');   

gulp.task('default', function () {
    gulp.src('./Content/*.less')
      .pipe(less())
      .pipe(gulp.dest('./Content/Generated-Css'));
});