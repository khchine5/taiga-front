CommentEditWysiwyg = (attachmentsFullService) ->
    link = ($scope, $el, $attrs) ->
        types = {
            userstories: "us",
            issues: "issue",
            tasks: "task"
        }

        uploadFile = (file, cb) ->
            return attachmentsFullService.addAttachment($scope.vm.projectId, $scope.vm.comment.comment.id, types[$scope.vm.comment.comment._name], file).then (result) ->
                cb(result.getIn(['file', 'name']), result.getIn(['file', 'url']))

        $scope.uploadFiles = (files, cb) ->
            for file in files
                uploadFile(file, cb)

    return {
        scope: true,
        link: link,
        template: """
            <div>
                <tg-wysiwyg
                    editonly
                    required
                    content='vm.comment.comment'
                    on-save="vm.saveComment(text, cb)"
                    on-cancel="vm.onEditMode({commentId: vm.comment.id})"
                    on-upload-file='uploadFiles(files, cb)'>
                </tg-wysiwyg>
            </div>
        """
    }

angular.module("taigaComponents")
    .directive("tgCommentEditWysiwyg", ["tgAttachmentsFullService", CommentEditWysiwyg])
