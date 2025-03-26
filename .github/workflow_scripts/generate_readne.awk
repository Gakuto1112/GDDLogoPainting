BEGINFILE {
    skip_line_count = 0;
    url_regex = @/\[([^\[\]\(\)]+)\]\([^\[\]\(\)]+\)/
}

{
    # 除外カウントが有効の場合はスキップ
    if(skip_line_count >= 1) {
        skip_line_count--;
        next;
    }

    # 除外行の検出
    if(index($0, "<!-- EXCLUDED_LINE -->") >= 1) {
        if(skip_line_count >= 1) skip_line_count--;
        next;
    }

    # 画像フォーマットの検出
    if($0 ~ /^!\[.+\]\(.+\)\r?$/) {
        skip_line_count = 1;
        next;
    }

    # URLフォーマットの検出
    while(match($0, url_regex, a)) {
        sub(url_regex, a[1]);
    }

    # 見出しの検出
    if($0 ~ /^#{2}/) {
        print "\n";
    }

    print;
}
